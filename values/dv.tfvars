# Sandbox dv overlay only. Keep dummy values below for variables.tf (client-identical).
# Live for Glue/S3/JDBC: buckets, db*, glueConnection*, glue_job_configs, env_prefix.
# Unused until those .tf files are enabled: postgres thresholds, IRSA, SES, SNS, Lambda, Dynamo.

#### Environment Identifiers ####
glueCodeVersion = "dv-v0.0.1"
env_prefix      = "isg-esatp-dv"

#### General & S3 Buckets ####
# Using your single sandbox bucket for both to bypass the global uniqueness restriction
storage_bucket = "isg-esatp-rcc-storage-os"
script_bucket  = "isg-esatp-rcc-scripts-os"

#### AWS Aurora PostgreSQL Credentials & Instance ####
dbInstance   = "database-1.cluster-c0x8ko8cis42.us-east-1.rds.amazonaws.com"
dbPort       = "5432"
dbName       = "postgres"
dbSecret     = "arn:aws:secretsmanager:us-east-1:979437352248:secret:rds!cluster-c625312d-fe5a-439f-8e96-719efb8e007a-04Wzo0"
dbSecretName = "rds!cluster-c625312d-fe5a-439f-8e96-719efb8e007a"

#### SAP S/4HANA Connection & Credentials ####
dbHostSAP       = "13b7c15d-848f-40b5-9259-c9c36ab85f56.hna1.prod-eu10.hanacloud.ondemand.com"
dbPortSAP       = "443"
dbSecretSAP     = "arn:aws:secretsmanager:us-east-1:979437352248:secret:sap-hana-ge359705-creds-KntuPI"
dbSecretNameSAP = "sap-hana-ge359705-creds"

Glue_DataConnect-S3-PG-noJDBC = "Custom_S3-PG_noJDBC"

#### Sandbox Network Configurations (Glue JDBC Connections) ####
# Using your confirmed working subnet and SG for the DB connection
glueConnectionSubnetID_DB  = "subnet-0fef3a48a9034a11a"
glueConnectionSG_DB        = ["sg-064d17369da2c94d6"]
glueConnectionAZ_DB        = "us-east-1d"

# Using your dedicated "subnet-glue" for the primary pipeline connections
glueConnectionSubnetID_NW1 = "subnet-0fef3a48a9034a11a"
glueConnectionAZ_NW1       = "us-east-1d"

# Repeating the known working Postgres Security Group 5 times 
# to satisfy the pipeline's connection indexing
glueConnectionSG_NW1       = [
  "sg-064d17369da2c94d6",
  "sg-064d17369da2c94d6",
  "sg-064d17369da2c94d6",
  "sg-064d17369da2c94d6",
  "sg-064d17369da2c94d6"
]

#### Glue Job Configurations ####
glue_job_configs = {
  worker_type              = "G.1X"
  number_of_workers        = 4
  worker_type_High         = "G.2X"
  number_of_workers_High   = 2
  glue_version             = "5.1"
  execution_class          = "STANDARD"
  glue_bucket_name         = "isg-esatp-rcc-scripts-os"
  glue_bucket_name_storage = "isg-esatp-rcc-storage-os"
  default_arguments = {
    "--datalake-formats"                 = "delta"
    "--enable-continuous-cloudwatch-log" = "true"
    "--enable-continuous-log-filter"     = "true"
    "--enable-glue-datacatalog"          = "true"
    "--enable-auto-scaling"              = "true"
    "--enable-metrics"                   = ""
    "--enable-spark-ui"                  = "true"
    "--job-language"                     = "python"
    "--spark-event-logs-path"            = "s3://isg-esatp-rcc-scripts-os/sparLogs/"
    "--TempDir"                          = "s3://isg-esatp-rcc-scripts-os/sparLogs/temp/"
    "--enable-job-insights"              = "true"
    "--conf"                             = "spark.eventLog.rolling.enabled=true"
    "--conf"                             = "spark.sql.catalog.glue_catalog.glue.skip-name-validation=true"
  }
}

#### Aurora PostgreSQL Resource Thresholds ####
postgres_name                           = "app-db"
number_of_read_replicas                 = 0
instance_class                          = "db.t3.medium"
engine_version                          = "18.3"
aurora_cpu_threshold                    = 70
aurora_memory_threshold                 = 1073741824
aurora_databaseconnection_threshold     = 50
aurora_replica_lag_threshold            = 200
aurora_read_iops_threshold              = 2000
aurora_write_iops_threshold             = 200
aurora_snapshot_storage_used_threshold  = 107374182400
cloudwatch_metric_period                = 300

#### Secrets Manager User Settings ####
secret_sme_name          = "esatp_sme"
secret_sme_db_engine     = "apsql"
secret_sme_recovery_days = 7
secret_sme_rotation_days = 30

secret_adm_name          = "esatp_adm"
secret_adm_db_engine     = "apsql"
secret_adm_recovery_days = 7
secret_adm_rotation_days = 30

#### Identity, EFS, & Subdomain Configurations ####
irsa_name            = "irsa-k8"
irsa_name_2          = "irsa-oth"
ses_subdomain        = "noreply-esatpdev"
security_aliases_prv = ["sa::workernode1", "sa::workernode2", "sa::varscanner"]
security_aliases_data= []
efs_name             = "workload-efs"
sns_name             = ["app"]

#### Lambda & DynamoDB Settings ####
tag_path           = "dv-0.0.1"
tag_path_layer     = "dv-0.0.1"
lambda_zip_generic = "generic_v1_0_0.zip"
write_capacity     = 10
read_capacity      = 5

sns_subscribers = [
  "neevangelista@globe.com.ph",
  "wmadiano@globe.com.ph"
]