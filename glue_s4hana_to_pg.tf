##### S4Hana Extract to S3
module "glue_extract_sap" {
  source = "./modules/aws-glue"

  providers = {
    aws.environment = aws.environment,
    aws.security    = aws.security,
    aws.dr          = aws.dr,
    aws.security_dr = aws.security_dr
  }

  s3_bucket_name = ["storage", "scripts"]
  name           = "sap_to_s3"
  sns_topic_name = null
  glue_database  = []

  source_secrets_manager_arn         = var.dbSecretSAP
  source_secrets_manager_name        = var.dbSecretNameSAP
  source_secrets_manager_kms_key_arn = "*"

  glue_connections = [
    {
      name                    = "sapdb"
      description             = "JDBC connection to S4Hana database"
      connection_type         = "JDBC"
      create_source_db_secret = false

      connection_properties = {
        JDBC_CONNECTION_URL = "jdbc:sap://${var.dbHostSAP}:${var.dbPortSAP}/"
      }

      physical_connection_requirements = [
        {
          availability_zone      = var.glueConnectionAZ_NW1
          subnet_id              = var.glueConnectionSubnetID_NW1
          security_group_id_list = [var.glueConnectionSG_NW1[3]]
        }
      ]
    }
  ]

  security_configurations = [
    {
      port_number        = 0
      protocol           = "-1"
      allow_ingress_from = []
    }
  ]

  glue_jobs = [
    {
      name              = "sap_2_s3"
      description       = "Pull SAP data and save to S3"
      glue_version      = "5.1"
      worker_type       = var.glue_job_configs.worker_type_High
      number_of_workers = var.glue_job_configs.number_of_workers_High
      connections       = ["sapdb"]
      tags              = { PIPELINE = "Test SAP to S3" }

      glue_job_command = [
        {
          name            = "glueetl"
          python_version  = "3"
          script_location = "s3://${local.bucket_name}/${local.aws_product_s3_prefix}/${local.commons_s3_prefix}/scripts/GlueSAP_to_s3.py"
        }
      ]

      execution_property = {
        max_concurrent_runs = 3
      }

      default_arguments = merge(
        var.glue_job_configs.default_arguments,
        {
          "--TempDir"        = "s3://${local.bucket_name}/${local.aws_product_s3_prefix}/tmp/"
          "--user-jars-first" = "true"
          "--secret_name"    = var.dbSecretNameSAP
          "--jdbc_url"       = "jdbc:sap://${var.dbHostSAP}:${var.dbPortSAP}/"
          "--s3_target_path" = "s3://${local.bucket_name_storage}/from_SAP"
          "--extra-jars"     = "s3://${local.bucket_name}/${local.aws_product_s3_prefix}/${local.commons_s3_prefix}/artifacts/ngdbc-2.29.7.jar,s3://${local.bucket_name}/${local.aws_product_s3_prefix}/${local.commons_s3_prefix}/artifacts/postgresql-42.7.13.jar"
          "--table_name"     = "aufk"
          "--query"          = ""
        }
      )
    }
  ]
}

##### S3 to PostgreSQL
module "glue_extract_s3pg" {
  source = "./modules/aws-glue"

  providers = {
    aws.environment = aws.environment,
    aws.security    = aws.security,
    aws.dr          = aws.dr,
    aws.security_dr = aws.security_dr
  }

  s3_bucket_name = ["storage", "scripts"]
  name           = "s3_to_pg"
  sns_topic_name = null
  glue_database  = []

  source_secrets_manager_arn         = var.dbSecret
  source_secrets_manager_name        = var.dbSecretName
  source_secrets_manager_kms_key_arn = "*"

  glue_connections = [
    {
      name                    = "postgres"
      description             = "JDBC connection to PostgreSQL database via Secrets Manager"
      connection_type         = "JDBC"
      create_source_db_secret = false

      connection_properties = {
        JDBC_CONNECTION_URL = "jdbc:postgresql://${var.dbInstance}:${var.dbPort}/${var.dbName}"
      }

      physical_connection_requirements = [
        {
          availability_zone      = var.glueConnectionAZ_NW1
          subnet_id              = var.glueConnectionSubnetID_NW1
          security_group_id_list = [var.glueConnectionSG_NW1[4]]
        }
      ]
    }
  ]

  security_configurations = [
    {
      port_number        = 0
      protocol           = "-1"
      allow_ingress_from = []
    }
  ]

  glue_jobs = [
    {
      name              = "s3_to_pg"
      description       = "ingest to Postgres"
      glue_version      = "5.1"
      worker_type       = var.glue_job_configs.worker_type_High
      number_of_workers = var.glue_job_configs.number_of_workers_High
      connections       = ["postgres"]
      tags              = { PIPELINE = "Test SAP to S3" }

      glue_job_command = [
        {
          name            = "glueetl"
          python_version  = "3"
          script_location = "s3://${local.bucket_name}/${local.aws_product_s3_prefix}/${local.commons_s3_prefix}/scripts/GlueS3_to_pg.py"
        }
      ]

      execution_property = {
        max_concurrent_runs = 3
      }

      default_arguments = merge(
        var.glue_job_configs.default_arguments,
        {
          "--TempDir"         = "s3://${local.bucket_name}/${local.aws_product_s3_prefix}/tmp/"
          "--user-jars-first" = "true"
          "--connection_name" = "${var.env_prefix}-s3_to_pg-glco-postgres"
          "--schema"          = "dgs4hana_tdir1_dbo"
          "--input_file_path" = "s3://${local.bucket_name_storage}/from_SAP/for_ingestion"
          "--extra-jars"      = "s3://${local.bucket_name}/${local.aws_product_s3_prefix}/${local.commons_s3_prefix}/artifacts/ngdbc-2.29.7.jar,s3://${local.bucket_name}/${local.aws_product_s3_prefix}/${local.commons_s3_prefix}/artifacts/postgresql-42.7.13.jar"
        }
      )
    }
  ]
}

##### S4Hana to PostgreSQL
module "glue_sap_to_pg" {
  source = "./modules/aws-glue"

  providers = {
    aws.environment = aws.environment,
    aws.security    = aws.security,
    aws.dr          = aws.dr,
    aws.security_dr = aws.security_dr
  }

  s3_bucket_name = ["storage", "scripts"]
  name           = "sap_to_pg"
  sns_topic_name = null
  glue_database  = []

  source_secrets_manager_arn         = var.dbSecret
  source_secrets_manager_name        = var.dbSecretName
  source_secrets_manager_kms_key_arn = "*"

  glue_connections = [
    {
      name                    = "sapdb"
      description             = "JDBC connection to S4Hana database"
      connection_type         = "JDBC"
      create_source_db_secret = false

      connection_properties = {
        JDBC_CONNECTION_URL = "jdbc:sap://${var.dbHostSAP}:${var.dbPortSAP}/"
      }

      physical_connection_requirements = [
        {
          availability_zone      = var.glueConnectionAZ_NW1
          subnet_id              = var.glueConnectionSubnetID_NW1
          security_group_id_list = [var.glueConnectionSG_NW1[3]]
        }
      ]
    },
    {
      name                    = "postgres"
      description             = "JDBC connection to PostgreSQL database via Secrets Manager"
      connection_type         = "JDBC"
      create_source_db_secret = false

      connection_properties = {
        JDBC_CONNECTION_URL = "jdbc:postgresql://${var.dbInstance}:${var.dbPort}/${var.dbName}"
      }

      physical_connection_requirements = [
        {
          availability_zone      = var.glueConnectionAZ_NW1
          subnet_id              = var.glueConnectionSubnetID_NW1
          security_group_id_list = [var.glueConnectionSG_NW1[3]]
        }
      ]
    }
  ]

  security_configurations = [
    {
      port_number        = 0
      protocol           = "-1"
      allow_ingress_from = []
    }
  ]

  glue_jobs = [
    {
      name              = "pipeline"
      description       = "Pull SAP data and save to S3"
      glue_version      = "5.1"
      worker_type       = var.glue_job_configs.worker_type_High
      number_of_workers = var.glue_job_configs.number_of_workers_High
      connections       = ["sapdb", "postgres"]
      tags              = { PIPELINE = "Test SAP to Postgre" }

      glue_job_command = [
        {
          name            = "glueetl"
          python_version  = "3"
          script_location = "s3://${local.bucket_name}/${local.aws_product_s3_prefix}/${local.commons_s3_prefix}/scripts/GlueSAP_to_Postgre.py"
        }
      ]

      execution_property = {
        max_concurrent_runs = 3
      }

      default_arguments = merge(
        var.glue_job_configs.default_arguments,
        {
          "--TempDir"         = "s3://${local.bucket_name}/${local.aws_product_s3_prefix}/tmp/"
          "--user-jars-first" = "true"
          "--secret_name"     = var.dbSecretNameSAP
          "--schema"          = "dgs4hana_tdir1_dbo"
          "--sap_jdbc_url"    = "jdbc:sap://${var.dbHostSAP}:${var.dbPortSAP}/"
          "--s3_target_path"  = "s3://${local.bucket_name_storage}/from_SAP"
          "--extra-jars"      = "s3://${local.bucket_name}/${local.aws_product_s3_prefix}/${local.commons_s3_prefix}/artifacts/ngdbc-2.29.7.jar,s3://${local.bucket_name}/${local.aws_product_s3_prefix}/${local.commons_s3_prefix}/artifacts/postgresql-42.7.13.jar"
          "--table_name"      = "set from step function"
          "--query"           = "set from step function"
          "--aws_region"      = data.aws_region.current.name
        }
      )
    }
  ]
}
