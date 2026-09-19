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

`glue.tf`, `glue_*.tf`, `eb_*.tf`, `sfn_bss.tf` / `sfn_mybss.tf`, `sfn_iccbs.tf`, `sfn_aprm.tf`, `sfn_sap_to_pg.tf`, `sf_bss_*.tpl` / `sf_mybss_*.tpl`, `sf_iccbs_*.tpl`, `sf_aprm_*.tpl`, `sf_sap_to_pg*.tpl`

## File renames (same WORA, extra first step)

Scan keys files by **name**. A client rename looks like `client_only` (new name) plus `sandbox_only` / `renames` (old name). That is still WORA.

On execute WORA:

1. `git mv` the sandbox file to the client name (keeps git history; does not change AWS if Terraform **module** addresses stay the same).
2. Then apply client **content** with the usual adapters. Do not leave two copies of the same pipeline.
3. Split files (e.g. `sfn_bss.tf` → `sfn_mybss.tf` + new `sfn_aprm.tf` / `sfn_iccbs.tf`): create the new sandbox files with adapters; drop modules that moved out of the old file.
4. Same-name files (`glue_aprm_*.tf`, `glue_iccbs_*.tf`, SAP SFN/EB) stay name-keyed as before.

Do **not** copy JFrog/postgres/network/tfvars either way. Sandbox extras stay (`eventbridge_bss_eom_gt`, `eventbridge_sap_to_pg_test`, `providers.tf` profile, `./modules`). Sandbox-born jobs are not auto-promoted to client.

**Vice versa** means the same Glue/SFN **job content** can run in both accounts after adapters — not that sandbox infra is written onto client.

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
2. Extra Glue modules: `glue_database = []` (catalog `etl` owned by Bayan `glue_mybss_bc_bt.tf` / `module.glue_extract`).
3. SFN: `templatefile(..., { env_prefix, aws_region, aws_account_id })` — not client `file()`.
4. ASL: keep relative `from_SAP/...` and notifier SFN; do not paste client SES or `s3://isg-esatp-dv-storage-os/...`.
5. Load Glue job name: `{env}-s3_to_pg-gljo-s3_to_pg` even if client main tpl says `sap_to_s3-gljo-s3_to_pg`.
6. Orphan `sf_sap_to_pg_big_data.tpl`: not wired on client; scanner skips it until a `.tf` references it.

## Last sync (2026-09-20, client `041a6e8`)

Renames (`git mv`) then client content + adapters:

- `glue_bc_*` / `glue_eom_*` / `glue_myb_eom_bt.tf` → `glue_mybss_*`
- `eb_bss_*` → `eb_mybss_*`; kept `eventbridge_bss_eom_gt`
- `sfn_bss.tf` → `sfn_mybss.tf`; added `sfn_aprm.tf`, `sfn_iccbs.tf` (`templatefile` + notifier)
- `sf_bss_*` → `sf_mybss_*`; new `sf_aprm_*`, `sf_iccbs_*`, `sf_mybss_eom_{bt,ic}.tpl`
- Same-name: `glue_aprm_acc.tf`, `glue_aprm_del.tf`, `glue_iccbs_bt.tf`, `glue_s4hana_to_pg.tf`, `eb_sap_to_pg.tf` (`cron(30 14)` small; big `step_functions` still `s4_2_pg_ab-sf`; kept test rule), `sf_sap_to_pg_big_2.tpl`

Bayan `glue_extract` keeps catalog `etl`. GT/IC/EOM `glue_database = []`.
