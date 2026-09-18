"""Cheap WORA gate. Run before reading overlays.

  py -3 wora_scan.py
  py -3 wora_scan.py --write-manifest   # after a completed sync

Prints only files whose *client* SHA changed since the last snapshot, plus
content keys (crons, Glue --args, ASL graph). Do not re-read unchanged files.
"""
from __future__ import annotations

import argparse
import hashlib
import json
import re
import subprocess
from pathlib import Path

ROOT = Path(__file__).resolve().parent
CLIENT = ROOT.parent / "atlas-isg-esatp"
MANIFEST = ROOT / "wora-manifest.json"

COPYABLE_GLOBS = [
    "glue.tf",
    "glue_*.tf",
    "eb_*.tf",
    "sfn_bss.tf",
    "sfn_sap_to_pg.tf",
    "sf_bss_*.tpl",
    "sf_sap_to_pg*.tpl",
]
NEVER_COPY = {
    "sfn_job_status.tf",
    "sf_job_status_notif.tpl",
    "sf_sap_to_pg_big_data.tpl",
    "postgres.tf",
    "ses.tf",
    "sns.tf",
    "lambda_poc.tf",
    "secret_manager.tf",
    "service_account.tf",
    "providers.tf",
}
SANDBOX_EXTRA_MODULES = {
    "eventbridge_bss_eom_gt",
    "eventbridge_sap_to_pg_test",
}
SANDBOX_EXTRA_CRONS = {
    "cron(15 3 3 * ? *)",
    "cron(15 15 * * ? *)",
}
ARG = re.compile(r'"--[^"]+"\s*=\s*(?:"[^"]*"|[^\s,#}\n]+)')
CRON = re.compile(r'schedule_expression_stepfunctions\s*=\s*"([^"]+)"')
MOD = re.compile(r'^module\s+"([^"]+)"', re.M)
JOBN = re.compile(r'"JobName(?:\.\$)?"\s*:\s*"([^"]+)"')
GRAPH = re.compile(r'"(Extract_[^"]+|Load_[^"]+)"')


def sha16(data: bytes) -> str:
    return hashlib.sha256(data).hexdigest()[:16]


def list_copyable(base: Path) -> list[str]:
    names: set[str] = set()
    for g in COPYABLE_GLOBS:
        for p in base.glob(g):
            if p.name not in NEVER_COPY:
                names.add(p.name)
    return sorted(names)


def git_head(repo: Path) -> str:
    try:
        return subprocess.check_output(
            ["git", "rev-parse", "HEAD"],
            cwd=repo,
            text=True,
        ).strip()
    except Exception:
        return ""


def keys_tf(text: str) -> dict:
    mods = [m for m in MOD.findall(text) if m not in SANDBOX_EXTRA_MODULES]
    crons = [c for c in CRON.findall(text) if c not in SANDBOX_EXTRA_CRONS]
    args = []
    for a in ARG.findall(text):
        a = re.sub(r"\s+", " ", a)
        if a.startswith('"--aws_region"'):
            a = '"--aws_region"="*"'
        args.append(a)
    return {"modules": mods, "crons": crons, "args": args}


def keys_tpl(text: str) -> dict:
    jobs = JOBN.findall(text)
    jobs = [
        j.replace("isg-esatp-dv-", "{}-")
        .replace("States.Format('{}-", "{}-")
        .replace("',$.env_prefix)", "")
        for j in jobs
    ]
    # Intentional sandbox Load name vs client typo sap_to_s3-gljo-s3_to_pg
    jobs = [j.replace("sap_to_s3-gljo-s3_to_pg", "s3_to_pg-gljo-s3_to_pg") for j in jobs]
    return {"graph": GRAPH.findall(text), "jobnames": jobs}


def content_unequal(name: str, client: str, sandbox: str) -> bool:
    if name.endswith(".tpl"):
        return keys_tpl(client) != keys_tpl(sandbox)
    c, s = keys_tf(client), keys_tf(sandbox)
    return (
        set(c["modules"]) != set(s["modules"])
        or set(c["crons"]) != set(s["crons"])
        or c["args"] != s["args"]
    )


def main() -> None:
    ap = argparse.ArgumentParser()
    ap.add_argument("--write-manifest", action="store_true")
    args = ap.parse_args()

    last = json.loads(MANIFEST.read_text(encoding="utf-8")) if MANIFEST.exists() else {}
    last_files = last.get("client_files") or {}
    client_git = git_head(CLIENT)
    client_names = list_copyable(CLIENT)
    sandbox_names = list_copyable(ROOT)

    client_files = {}
    changed, new, unchanged = [], [], []
    must_apply, client_only = [], []

    for name in client_names:
        raw = (CLIENT / name).read_bytes()
        h = sha16(raw)
        client_files[name] = h
        prev = last_files.get(name)
        if prev is None:
            new.append(name)
        elif prev != h:
            changed.append(name)
        else:
            unchanged.append(name)
        if name not in sandbox_names:
            client_only.append(name)
            continue
        ct = raw.decode("utf-8")
        st = (ROOT / name).read_text(encoding="utf-8")
        if content_unequal(name, ct, st):
            must_apply.append(name)

    report = {
        "client_git": client_git,
        "last_client_git": last.get("client_git") or "",
        "client_only_not_on_sandbox": client_only,
        "changed_vs_last_client": changed,
        "new_vs_last_client": new,
        "unchanged_count": len(unchanged),
        "must_apply_content": must_apply,
        "read_these": sorted(set(changed + new + client_only + must_apply)),
        "client_files": client_files,
    }

    print("client_git:", client_git)
    print("last_manifest_git:", report["last_client_git"] or "(none)")
    print("unchanged_client_files:", report["unchanged_count"])
    print("changed_vs_last:", changed or "-")
    print("new_vs_last:", new or "-")
    print("client_only:", client_only or "-")
    print("must_apply_content:", must_apply or "-")
    print("READ_THESE:", report["read_these"] or "-")

    if args.write_manifest:
        MANIFEST.write_text(
            json.dumps(
                {
                    "client_git": client_git,
                    "client_files": client_files,
                    "last_sync_must_apply": must_apply,
                    "notes": [
                        "Client Load JobName sap_to_s3-gljo-s3_to_pg is treated as s3_to_pg-gljo-s3_to_pg",
                        "Do not copy NEVER_COPY or ./modules or JFrog the other way",
                        "Keep sandbox extras eventbridge_bss_eom_gt and eventbridge_sap_to_pg_test",
                    ],
                },
                indent=2,
            )
            + "\n",
            encoding="utf-8",
        )
        print("wrote", MANIFEST)


if __name__ == "__main__":
    main()
