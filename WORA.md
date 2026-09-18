# WORA (sandbox overlay)

Client: `../atlas-isg-esatp`  
Sandbox: this folder (`atlas-isg-esatp_rcc`)

**Direction:** client job/rule/SFN **content** → sandbox. Never dump sandbox adapters onto client. New sandbox-only files are **not** auto-promoted to client.

## How to use this tooling

Always from `atlas-isg-esatp_rcc`. You can run the commands, or ask the agent to run them.

1. **Scan** (after client Terraform was updated):

   ```bash
   py -3 wora_scan.py
   ```

2. **Read the output, then decide:**
   - If `READ_THESE` and `must_apply_content` are `-` → **stop**. Do not run WORA. Do not run `--write-manifest`.
   - If those lists have file names → tell the agent to **execute WORA**. Paste the scan output if you can. The agent must only open those files and apply client **content** with sandbox adapters (see below). Do not re-read the whole client and sandbox trees.

3. **After WORA finishes**, snapshot hashes so the next scan can skip unchanged files:

   ```bash
   py -3 wora_scan.py --write-manifest
   ```

`--write-manifest` does **not** copy Terraform. It only updates `wora-manifest.json` (client `HEAD` + per-file SHA16). Run it only after a completed sync.

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

## Last sync (2026-09-19, client `aa2129e`)

Applied (client content + sandbox adapters):

- `sfn_sap_to_pg.tf` two machines: `s4_2_pg_as` / `s4_2_pg_ab` → `sf_sap_to_pg_small_2.tpl` / `sf_sap_to_pg_big_2.tpl` (`templatefile` + notifier)
- `eb_sap_to_pg.tf` rules `s4_2_pgs_as` `cron(50 15 …)` and `s4_2_pgs_ab` `cron(0 18 …)`; big rule `step_functions` points at `s4_2_pg_ab-sf` (client still has `s4_2_pg_as-sf` on that field). Kept extra `eventbridge_sap_to_pg_test` on `s4_2_pg_as`
- `glue_s4hana_to_pg.tf` (`./modules/aws-glue`, `glue_database = []`, `--aws_region` = `data.aws_region.current.name`). Removed colliding `glue_sap_to_s3.tf` / `glue_s3_to_pg.tf`
- Copied `sf_sap_to_pg_{small,small_2,big,big_2}.tpl` with notifier rewrite

Hash-only / adapter-only (no job-arg or BSS cron change): `eb_bss_*.tf`, `glue_aprm_acc.tf`, `glue_aprm_del.tf`, `glue_bc_*.tf`, `glue_eom_ic.tf`, `glue_iccbs_ic.tf`, `sf_sap_to_pg_acdoca.tpl`
