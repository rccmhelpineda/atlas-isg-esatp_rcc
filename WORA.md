# WORA (sandbox overlay)

Client: `../atlas-isg-esatp`  
Sandbox: this folder (`atlas-isg-esatp_rcc`)

**Direction:** client job/rule/SFN **content** → sandbox. Never dump sandbox adapters onto client. New sandbox-only files are **not** auto-promoted to client.

## Token-saving gate (do this first)

```bash
cd atlas-isg-esatp_rcc
py -3 wora_scan.py
```

- If `unchanged_client_files` covers everything and `READ_THESE` is `-`, **stop**. Do not re-read overlays.
- Only open files in `READ_THESE` / `must_apply_content`.
- After a finished sync: `py -3 wora_scan.py --write-manifest`

`wora-manifest.json` stores client `HEAD` + per-file SHA16. Next WORA compares hashes, not whole trees.

## Copyable (content only)

`glue.tf`, `glue_*.tf`, `eb_*.tf`, `sfn_bss.tf`, `sfn_sap_to_pg.tf`, `sf_bss_*.tpl`, `sf_sap_to_pg*.tpl`

## Never copy (either direction)

| Stay on client | Stay on sandbox |
|---|---|
| JFrog `source` + `version` | `./modules/**`, `providers.tf` (`profile = "rcc-mhel"`) |
| `postgres.tf`, SES/SNS, secrets, lambda, IRSA | `values/dv.tfvars` RCC facts |
| `sfn_job_status.tf`, `sf_job_status_notif.tpl` | Extra `glue_database = []` on GT/IC/EOM |
| Client `pd`/`st` tfvars | SFN `templatefile` + notifier ARN rewrite |
| | EB `-sf` → `-sfn` mapping; `jsonencode` env_prefix |
| | Extra rules: `eventbridge_bss_eom_gt`, `eventbridge_sap_to_pg_test` |

## Adapter when copying a file

1. `source` → `./modules/aws-glue` (or eventbridge / step-functions / s3). Drop `version`.
2. Extra Glue modules: `glue_database = []` (catalog `etl` owned by Bayan `glue_bc_bt.tf`).
3. SFN: `templatefile(..., { env_prefix, aws_region, aws_account_id })` — not client `file()`.
4. ASL: keep relative `from_SAP/...` and notifier SFN; do not paste client SES or `s3://isg-esatp-dv-storage-os/...`.
5. Load Glue job name: `{env}-s3_to_pg-gljo-s3_to_pg` even if client main tpl says `sap_to_s3-gljo-s3_to_pg`.
6. Orphan `sf_sap_to_pg_big_data.tpl`: not wired on client; scanner skips it until a `.tf` references it.

## Last sync (2026-09-16, client `9ac6f5c` / `dv`)

Applied:

- `glue_s3_to_pg.tf`: `--connection_name`, default file `.json`
- `eb_sap_to_pg.tf` copy rule: `cron(35 7 * * ? *)`

Left as-is (already matched or sandbox extras): APRM Glue, BSS jobs/crons, SAP SFN modules, Load JobName adapter, EOM/test EventBridge.
