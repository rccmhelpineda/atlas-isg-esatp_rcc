####
glueCodeVersion = "dv-v0.0.1"

### Sandbox S3 Buckets ###
storage_bucket = "isg-esatp-glue-979437352248"
script_bucket  = "isg-esatp-glue-979437352248"

### Sandbox PostgreSQL Database & Secrets Manager ###
dbSecret     = "arn:aws:secretsmanager:us-east-1:979437352248:secret:RDS-PostgreSQL-DB-Credentials-RCCxGlobe_ESATP-AT4qkC"
dbSecretName = "RDS-PostgreSQL-DB-Credentials-RCCxGlobe_ESATP-AT4qkC"

# Optional SAP Mock/Stub in Sandbox
dbSecretSAP     = "arn:aws:secretsmanager:us-east-1:979437352248:secret:RDS-PostgreSQL-DB-Credentials-RCCxGlobe_ESATP-AT4qkC"
dbSecretNameSAP = "RDS-PostgreSQL-DB-Credentials-RCCxGlobe_ESATP-AT4qkC"

dbInstance = "database-1-instance-1.c0x8ko8cis42.us-east-1.rds.amazonaws.com"
dbName     = "postgres"
dbHostSAP  = "database-1-instance-1.c0x8ko8cis42.us-east-1.rds.amazonaws.com"
dbPortSAP  = 5432
Glue_DataConnect-S3-PG-noJDBC = "temp"

##################
irsa_name = "irsa-k8"
irsa_name_2 = "irsa-oth"
security_aliases_prv = ["sa::workernode1","sa::workernode2","sa::varscanner"]
security_aliases_data = []
efs_name = "workload-efs"

# RDS Configurations
postgres_name = "app-db"
number_of_read_replicas = 0
instance_class = "db.t3.medium"
aurora_cpu_threshold                   = 70
aurora_memory_threshold                = 3758096384
aurora_databaseconnection_threshold    = 10
aurora_replica_lag_threshold           = 120
aurora_read_iops_threshold             = 10
aurora_write_iops_threshold            = 10
aurora_snapshot_storage_used_threshold = 3758096384
cloudwatch_metric_period               = 60
engine_version = "18.3"

### Secrets SME User ###
secret_sme_name = "esatp_sme"
secret_sme_db_engine = "apsql"
secret_sme_recovery_days = 7
secret_sme_rotation_days = 30

### Secrets ESATP_ADM User ###
secret_adm_name = "esatp_adm"
secret_adm_db_engine = "apsql"
secret_adm_recovery_days = 7
secret_adm_rotation_days = 30

# Lambda
tag_path = "dv-0.0.1"
tag_path_layer = "dv-0.0.1"
lambda_zip_generic = "generic_v1_0_0.zip"

## DynamoDB
write_capacity = 10
read_capacity = 5

## GLUE
glue_job_configs = {
    worker_type = "G.1X"
    number_of_workers  = 2
    glue_version       = "5.1"
    execution_class    = "STANDARD"
    glue_bucket_name   = "isg-esatp-glue-979437352248"
    glue_bucket_name_storage = "isg-esatp-glue-979437352248"
    default_arguments = {
        "--datalake-formats" = "delta"
        "--enable-continuous-cloudwatch-log" = "true"
        "--enable-continuous-log-filter"     = "true"
        "--enable-glue-datacatalog" = "true"
        "--enable-auto-scaling" = "true"
        "--enable-metrics"  = ""
        "--enable-spark-ui" = "true"
        "--job-language"    = "python"
        "--spark-event-logs-path" = "s3://isg-esatp-glue-979437352248/sparLogs/"
        "--TempDir"= "s3://isg-esatp-glue-979437352248/sparLogs/temp/" 
        "--enable-job-insights" = "true"
        "--conf" = "spark.eventLog.rolling.enabled=true"
        "--conf" = "spark.sql.catalog.glue_catalog.glue.skip-name-validation=true"
    }
}

glueConnectionSG_DB       = ["sg-064d17369da2c94d6"]
glueConnectionSubnetID_DB = "subnet-0bec4872b01703185"
glueConnectionAZ_DB       = "us-east-1d"

glueConnectionSG_NW1       = ["sg-064d17369da2c94d6"]
glueConnectionSubnetID_NW1 = "subnet-0bec4872b01703185"
glueConnectionAZ_NW1       = "us-east-1d"
