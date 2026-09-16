variable "dbPort" {
  type        = string
  description = "Port for the Postgres database"
}

variable "irsa_name" {
  type        = string
  description = "eks service account"
}

variable "irsa_name_2" {
  type        = string
  description = "sqs variable name for bulk"
}

variable "ses_subdomain" {
   type        = string
   description = "ses subdomain variable"
}

variable "security_aliases_prv" {
  type        = list(string)
  description = "security aliases for whitelisting in efs ingress"
}

variable "security_aliases_data" {
  type        = list(string)
  description = "security aliases for whitelisting in efs ingress"
}

variable "sns_name" {
  type        = list(string)
  description = "sns topic"  
}

variable "efs_name" {
   type        = string
   description = "esf name variable"
}

### Postgres Configurations###

variable "postgres_name" {
  type        = string
  description = "Aurora PostgreSQL Name"
}

variable "engine_version" {
   type        = string
   description = "Specify the aurora verions to use"
}

variable "cloudwatch_metric_period" {
   type        = number
   description = "Specifies the number limit for write iops"
}

####Secrets SME User####
variable "secret_sme_name" {
  type        = string
  description = "Name of secret."
}

variable "secret_sme_db_engine" {
  type        = string
  description = "Name of the database in which credentials will be stored."
}

variable "secret_sme_recovery_days" {
  type        = number
  description = "Specifies the number of days that AWS Secrets Manager waits before it can delete the secret. This value can be 0 to force deletion without recovery or range from 7 to 30 days."
}

 variable "secret_sme_rotation_days" {
   type        = number
   description = "Specifies the number of days between automatic scheduled rotations of the secret."
}

####Secrets QAE User####
variable "secret_adm_name" {
  type        = string
  description = "Name of secret."
}

variable "secret_adm_db_engine" {
  type        = string
  description = "Name of the database in which credentials will be stored."
}

# variable "secret_adm_db_username" {
#    type        = string
#    description = "Username of database sub-user"
# }

variable "secret_adm_recovery_days" {
  type        = number
  description = "Specifies the number of days that AWS Secrets Manager waits before it can delete the secret. This value can be 0 to force deletion without recovery or range from 7 to 30 days."
}

variable "secret_adm_rotation_days" {
   type        = number
   description = "Specifies the number of days between automatic scheduled rotations of the secret."
}

variable "aurora_cpu_threshold" {
   type        = number
   description = "Specifies the number limit of CPU"
}

variable "aurora_memory_threshold" {
   type        = number
   description = "Specifies the number limit of Memory"
}

variable "aurora_databaseconnection_threshold" {
   type        = number
   description = "Specifies the number limit of allowed database connections at a time"
}

variable "aurora_replica_lag_threshold" {
   type        = number
   description = "Specifies the number limit replication delays"
}

variable "aurora_read_iops_threshold" {
   type        = number
   description = "Specifies the number limit for write iops"
}

variable "aurora_write_iops_threshold" {
   type        = number
   description = "Specifies the number limit for write iops"
}

variable "aurora_snapshot_storage_used_threshold" {
   type        = number
   description = "Specifies the number limit for write iops"
}

variable "number_of_read_replicas" {
  type        = number
  description = "number of replicas"
}

variable "instance_class" {
  type        = string
  description = "postgres instance class"
}

variable "tag_path" {
  type        = string
  description = "lambda script path for SFTP functions"
}

variable "tag_path_layer" {
  type        = string
  description = "lambda layer path for SFTP functions"
}


variable "lambda_zip_generic" {
  type        = string
  description = "lambda script filename for Generic functions"
}

variable "write_capacity" {
  type        = number
  description = "set write limit for dynamoDB"  
}

variable "read_capacity" {
  type        = number
  description = "set read limit for dynamoDB"  
}

variable "sns_subscribers" {
    type = list(string)
}

variable "script_bucket" {
    type = string
}

variable "storage_bucket" {
    type = string
}

variable "default_passed_parameter" {
  description = "Default --passed_parameter / bill-cycle suffix used in specs (01 = BC01)."
  type        = string
  default     = "01"
}

variable "glue_job_configs" {
  type = object({
    worker_type            = string
    number_of_workers      = number
    worker_type_High       = string
    number_of_workers_High = number
    glue_version           = string
    execution_class        = string
    glue_bucket_name       = string
    glue_bucket_name_storage = string
    default_arguments      = map(string)
  })
}

variable "Glue_DataConnect-S3-PG-noJDBC" { type = string }
variable "dbInstance" { type = string }
variable "dbName" { type = string }
variable "dbHostSAP" { type = string }
variable "dbPortSAP" { type = string }
variable "dbSecret" { type = string }
variable "dbSecretName" { type = string }
variable "dbSecretSAP" { type = string }
variable "dbSecretNameSAP" { type = string }
variable "glueConnectionSubnetID_DB" { type = string }
variable "glueConnectionSG_DB" { type = list(string) }
variable "glueConnectionAZ_DB" { type = string }
variable "glueConnectionSubnetID_NW1" { type = string }
variable "glueConnectionSG_NW1" { type = list(string) }
variable "glueConnectionAZ_NW1" { type = string }
variable "glueCodeVersion" { type = string }
variable "env_prefix" { type = string }

locals {
  bucket_name = var.script_bucket
  bucket_arn  = "arn:aws:s3:::${local.bucket_name}"
  bucket_name_storage = var.storage_bucket

  commons_root           = "${path.module}/../_commons"
  commons_s3_prefix      = "core/commons"
  aws_product_s3_prefix  = "glue/${var.glueCodeVersion}"

  s3_script = {
    GluePipelinesOrchestrator = "${local.commons_s3_prefix}/scripts/GluePipelinesOrchestrator.py"
    GlueSpreadsheet           = "${local.commons_s3_prefix}/scripts/GlueSpreadsheet.py"
    GlueText                  = "${local.commons_s3_prefix}/scripts/GlueText.py"
    GlueDbSpCaller            = "${local.commons_s3_prefix}/scripts/GlueDbSpCaller.py"
  }

  s3_jar = "s3://${local.bucket_name}/${local.aws_product_s3_prefix}/${local.commons_s3_prefix}/artifacts/spark-excel_2.12-3.3.1_0.18.7.jar"

  py = {
    CustomErrorLibs         = "${local.commons_s3_prefix}/imports/CustomErrorLibs.py"
    CustomDbConnLibs        = "${local.commons_s3_prefix}/imports/CustomDbConnLibs.py"
    Utils                   = "${local.commons_s3_prefix}/imports/Utils.py"
    UtilsAWS                = "${local.commons_s3_prefix}/imports/UtilsAWS.py"
    SpreadsheetIngester     = "${local.commons_s3_prefix}/imports/SpreadsheetIngester.py"
    TextIngester            = "${local.commons_s3_prefix}/imports/TextIngester.py"
    DbSpCallerEx            = "${local.commons_s3_prefix}/imports/DbSpCallerEx.py"
    FileExporter            = "${local.commons_s3_prefix}/imports/FileExporter.py"
    ExportBillCycleMapping  = "${local.commons_s3_prefix}/imports/ExportBillCycleMapping.py"
  }

  extra_py = {
    orchestrator = join(",", [
      "s3://${local.bucket_name}/${local.aws_product_s3_prefix}/${local.py.CustomErrorLibs}",
    ])
    spreadsheet = join(",", [
      "s3://${local.bucket_name}/${local.aws_product_s3_prefix}/${local.py.SpreadsheetIngester}",
      "s3://${local.bucket_name}/${local.aws_product_s3_prefix}/${local.py.Utils}",
      "s3://${local.bucket_name}/${local.aws_product_s3_prefix}/${local.py.UtilsAWS}",
      "s3://${local.bucket_name}/${local.aws_product_s3_prefix}/${local.py.CustomDbConnLibs}",
      "s3://${local.bucket_name}/${local.aws_product_s3_prefix}/${local.py.CustomErrorLibs}",
    ])
    text = join(",", [
      "s3://${local.bucket_name}/${local.aws_product_s3_prefix}/${local.py.TextIngester}",
      "s3://${local.bucket_name}/${local.aws_product_s3_prefix}/${local.py.Utils}",
      "s3://${local.bucket_name}/${local.aws_product_s3_prefix}/${local.py.UtilsAWS}",
      "s3://${local.bucket_name}/${local.aws_product_s3_prefix}/${local.py.CustomDbConnLibs}",
      "s3://${local.bucket_name}/${local.aws_product_s3_prefix}/${local.py.CustomErrorLibs}",
    ])
    dbsp = join(",", [
      "s3://${local.bucket_name}/${local.aws_product_s3_prefix}/${local.py.DbSpCallerEx}",
      "s3://${local.bucket_name}/${local.aws_product_s3_prefix}/${local.py.UtilsAWS}",
      "s3://${local.bucket_name}/${local.aws_product_s3_prefix}/${local.py.CustomDbConnLibs}",
      "s3://${local.bucket_name}/${local.aws_product_s3_prefix}/${local.py.CustomErrorLibs}",
    ])
    dbsp_export = join(",", [
      "s3://${local.bucket_name}/${local.aws_product_s3_prefix}/${local.py.DbSpCallerEx}",
      "s3://${local.bucket_name}/${local.aws_product_s3_prefix}/${local.py.UtilsAWS}",
      "s3://${local.bucket_name}/${local.aws_product_s3_prefix}/${local.py.CustomDbConnLibs}",
      "s3://${local.bucket_name}/${local.aws_product_s3_prefix}/${local.py.CustomErrorLibs}",
      "s3://${local.bucket_name}/${local.aws_product_s3_prefix}/${local.py.FileExporter}",
      "s3://${local.bucket_name}/${local.aws_product_s3_prefix}/${local.py.ExportBillCycleMapping}",
    ])
  }

  extra_jars = "${local.s3_jar}"
}