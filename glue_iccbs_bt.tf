locals {
  folder_iccbs_bt = "${local.bucket_name_storage}/iccbs_bayn/"
}

module "glue_iccbs_bt" {
  source = "./modules/aws-glue"

  providers = {
    aws.environment = aws.environment,
    aws.security    = aws.security,
    aws.dr          = aws.dr,
    aws.security_dr = aws.security_dr
  }

  s3_bucket_name = ["storage", "scripts"]
  name           = "iccbs_bt"
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
          security_group_id_list = [var.glueConnectionSG_NW1[0]]
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
      name              = "extract_1"
      description       = "ICCBS BT : sap_bdef_USD.txt → sap_bdef_usd_ssis"
      glue_version      = "5.1"
      worker_type       = var.glue_job_configs.worker_type
      number_of_workers = var.glue_job_configs.number_of_workers
      connections       = ["postgres"]
      tags              = { INGESTION_TYPE = "TXT_NUMBERED_IMPUTED", PIPELINE = "ICCBS BT" }

      glue_job_command = [
        {
          name            = "glueetl"
          python_version  = "3"
          script_location = "s3://${local.bucket_name}/${local.aws_product_s3_prefix}/${local.s3_script.GlueText}"
        }
      ]

      execution_property = {
        max_concurrent_runs = 2
      }

      default_arguments = merge(
        var.glue_job_configs.default_arguments,
        {
          "--TempDir"            = "s3://${local.bucket_name_storage}/${local.aws_product_s3_prefix}/tmp/"
          "--connection_name"    = "${var.env_prefix}-iccbs_bt-glco-postgres"
          "--extra-py-files"     = local.extra_py.text
          "--target_table"       = "sdbtdir1_iccbs_dbo.sap_bdef_usd_ssis"
          "--folder_location"    = local.folder_iccbs_bt
          "--input_file_name"    = "sap_bdef_USD.txt"
          "--delimiter_regex"    = "\\t"
          "--filter_record_type" = "ALL"
          "--expected_columns"   = "30"
          "--col_label"          = "column"
          "--row_number_label"   = "zrownumber"
          "--include_date"       = "dateread"
          "--include_filename"   = "filename"
        }
      )
    },
    {
      name              = "extract_2"
      description       = "ICCBS BT : sap_bdef_PHP.txt → sap_bdef_php_ssis"
      glue_version      = "5.1"
      worker_type       = var.glue_job_configs.worker_type
      number_of_workers = var.glue_job_configs.number_of_workers
      connections       = ["postgres"]
      tags              = { INGESTION_TYPE = "TXT_NUMBERED_IMPUTED", PIPELINE = "ICCBS BT" }

      glue_job_command = [
        {
          name            = "glueetl"
          python_version  = "3"
          script_location = "s3://${local.bucket_name}/${local.aws_product_s3_prefix}/${local.s3_script.GlueText}"
        }
      ]

      execution_property = {
        max_concurrent_runs = 2
      }

      default_arguments = merge(
        var.glue_job_configs.default_arguments,
        {
          "--TempDir"            = "s3://${local.bucket_name_storage}/${local.aws_product_s3_prefix}/tmp/"
          "--connection_name"    = "${var.env_prefix}-iccbs_bt-glco-postgres"
          "--extra-py-files"     = local.extra_py.text
          "--target_table"       = "sdbtdir1_iccbs_dbo.sap_bdef_php_ssis"
          "--folder_location"    = local.folder_iccbs_bt
          "--input_file_name"    = "sap_bdef_PHP.txt"
          "--delimiter_regex"    = "\\t"
          "--filter_record_type" = "ALL"
          "--expected_columns"   = "30"
          "--col_label"          = "column"
          "--row_number_label"   = "zrownumber"
          "--include_date"       = "dateread"
          "--include_filename"   = "filename"
        }
      )
    },
    {
      name              = "extract_3"
      description       = "ICCBS BT : sap_blcb_USD.txt → sap_blcb_usd_ssis"
      glue_version      = "5.1"
      worker_type       = var.glue_job_configs.worker_type
      number_of_workers = var.glue_job_configs.number_of_workers
      connections       = ["postgres"]
      tags              = { INGESTION_TYPE = "TXT_NUMBERED_IMPUTED", PIPELINE = "ICCBS BT" }

      glue_job_command = [
        {
          name            = "glueetl"
          python_version  = "3"
          script_location = "s3://${local.bucket_name}/${local.aws_product_s3_prefix}/${local.s3_script.GlueText}"
        }
      ]

      execution_property = {
        max_concurrent_runs = 2
      }

      default_arguments = merge(
        var.glue_job_configs.default_arguments,
        {
          "--TempDir"            = "s3://${local.bucket_name_storage}/${local.aws_product_s3_prefix}/tmp/"
          "--connection_name"    = "${var.env_prefix}-iccbs_bt-glco-postgres"
          "--extra-py-files"     = local.extra_py.text
          "--target_table"       = "sdbtdir1_iccbs_dbo.sap_blcb_usd_ssis"
          "--folder_location"    = local.folder_iccbs_bt
          "--input_file_name"    = "sap_blcb_USD.txt"
          "--delimiter_regex"    = "\\t"
          "--filter_record_type" = "ALL"
          "--expected_columns"   = "30"
          "--col_label"          = "column"
          "--row_number_label"   = "zrownumber"
          "--include_date"       = "dateread"
          "--include_filename"   = "filename"
        }
      )
    },
    {
      name              = "extract_4"
      description       = "ICCBS BT : sap_blcb_PHP.txt → sap_blcb_php_ssis"
      glue_version      = "5.1"
      worker_type       = var.glue_job_configs.worker_type
      number_of_workers = var.glue_job_configs.number_of_workers
      connections       = ["postgres"]
      tags              = { INGESTION_TYPE = "TXT_NUMBERED_IMPUTED", PIPELINE = "ICCBS BT" }

      glue_job_command = [
        {
          name            = "glueetl"
          python_version  = "3"
          script_location = "s3://${local.bucket_name}/${local.aws_product_s3_prefix}/${local.s3_script.GlueText}"
        }
      ]

      execution_property = {
        max_concurrent_runs = 2
      }

      default_arguments = merge(
        var.glue_job_configs.default_arguments,
        {
          "--TempDir"            = "s3://${local.bucket_name_storage}/${local.aws_product_s3_prefix}/tmp/"
          "--connection_name"    = "${var.env_prefix}-iccbs_bt-glco-postgres"
          "--extra-py-files"     = local.extra_py.text
          "--target_table"       = "sdbtdir1_iccbs_dbo.sap_blcb_php_ssis"
          "--folder_location"    = local.folder_iccbs_bt
          "--input_file_name"    = "sap_blcb_PHP.txt"
          "--delimiter_regex"    = "\\t"
          "--filter_record_type" = "ALL"
          "--expected_columns"   = "30"
          "--col_label"          = "column"
          "--row_number_label"   = "zrownumber"
          "--include_date"       = "dateread"
          "--include_filename"   = "filename"
        }
      )
    },
    {
      name              = "extract_5"
      description       = "ICCBS BT : sap_blcu_PHP.txt → sap_blcu_php_ssis"
      glue_version      = "5.1"
      worker_type       = var.glue_job_configs.worker_type
      number_of_workers = var.glue_job_configs.number_of_workers
      connections       = ["postgres"]
      tags              = { INGESTION_TYPE = "TXT_NUMBERED_IMPUTED", PIPELINE = "ICCBS BT" }

      glue_job_command = [
        {
          name            = "glueetl"
          python_version  = "3"
          script_location = "s3://${local.bucket_name}/${local.aws_product_s3_prefix}/${local.s3_script.GlueText}"
        }
      ]

      execution_property = {
        max_concurrent_runs = 2
      }

      default_arguments = merge(
        var.glue_job_configs.default_arguments,
        {
          "--TempDir"            = "s3://${local.bucket_name_storage}/${local.aws_product_s3_prefix}/tmp/"
          "--connection_name"    = "${var.env_prefix}-iccbs_bt-glco-postgres"
          "--extra-py-files"     = local.extra_py.text
          "--target_table"       = "sdbtdir1_iccbs_dbo.sap_blcu_php_ssis"
          "--folder_location"    = local.folder_iccbs_bt
          "--input_file_name"    = "sap_blcu_PHP.txt"
          "--delimiter_regex"    = "\\t"
          "--filter_record_type" = "ALL"
          "--expected_columns"   = "30"
          "--col_label"          = "column"
          "--row_number_label"   = "zrownumber"
          "--include_date"       = "dateread"
          "--include_filename"   = "filename"
        }
      )
    }
  ]
}
