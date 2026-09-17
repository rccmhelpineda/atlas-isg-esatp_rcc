locals {
  folder_iccbs_ic = "${local.bucket_name_storage}/iccbs_inov/"
}

module "glue_iccbs_ic" {
  source = "./modules/aws-glue"

  providers = {
    aws.environment = aws.environment,
    aws.security    = aws.security,
    aws.dr          = aws.dr,
    aws.security_dr = aws.security_dr
  }

  s3_bucket_name = ["storage", "scripts"]
  name           = "iccbs_ic"
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
      name              = "extract_mgr"
      description       = "isg-esatp-dv-iccbs_inov_preload_extract-glue : Orchestrator: start extract child jobs"
      glue_version      = "5.1"
      worker_type       = var.glue_job_configs.worker_type_High
      number_of_workers = var.glue_job_configs.number_of_workers
      tags              = { PIPELINE = "MyBSS EOM Innove" }

      glue_job_command  = [
        {
          name            = "glueetl"
          python_version  = "3"
          script_location = "s3://${local.bucket_name}/${local.aws_product_s3_prefix}/${local.s3_script.GluePipelinesOrchestrator}"
        }
      ]

      execution_property = {
        max_concurrent_runs = 1
      }

      default_arguments = merge(
        var.glue_job_configs.default_arguments,
        {
        "--TempDir"          = "s3://${local.bucket_name_storage}/${local.commons_s3_prefix}/tmp/"
        "--extra-py-files"   = local.extra_py.orchestrator
        "--job_list"         = "${var.env_prefix}-iccbs_ic-gljo-extract_1,${var.env_prefix}-iccbs_ic-gljo-extract_2,${var.env_prefix}-iccbs_ic-gljo-extract_3,${var.env_prefix}-iccbs_ic-gljo-extract_4,${var.env_prefix}-iccbs_ic-gljo-extract_5"
        }
      )
    },
    
    {
      name              = "extract_1"
      description       = "ICCBS IC : sap_flcu_PHP.txt → sap_flcu_php_ssis"
      glue_version      = "5.1"
      worker_type       = var.glue_job_configs.worker_type
      number_of_workers = var.glue_job_configs.number_of_workers
      connections       = ["postgres"]
      tags              = { INGESTION_TYPE = "TXT_NUMBERED", PIPELINE = "ICCBS IC" }

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
          "--connection_name"    = "${var.env_prefix}-iccbs_ic-glco-postgres"
          "--extra-py-files"     = local.extra_py.text
          "--target_table"       = "sap_flcu_php_ssis"
          "--folder_location"    = local.folder_iccbs_ic
          "--input_file_name"    = "sap_flcu_PHP.txt"
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
      description       = "ICCBS IC : sap_flcb_USD.txt → sap_flcb_usd_ssis"
      glue_version      = "5.1"
      worker_type       = var.glue_job_configs.worker_type
      number_of_workers = var.glue_job_configs.number_of_workers
      connections       = ["postgres"]
      tags              = { INGESTION_TYPE = "TXT_NUMBERED", PIPELINE = "ICCBS IC" }

      glue_job_command = [
        {
          name            = "glueetl"
          python_version  = "3"
          script_location = "s3://${local.bucket_name}/${local.aws_product_s3_prefix}/${local.s3_script.GlueText}"
        }
      ]

      execution_property = {
        max_concurrent_runs = 3
      }

      default_arguments = merge(
        var.glue_job_configs.default_arguments,
        {
          "--TempDir"            = "s3://${local.bucket_name_storage}/${local.aws_product_s3_prefix}/tmp/"
          "--connection_name"    = "${var.env_prefix}-iccbs_ic-glco-postgres"
          "--extra-py-files"     = local.extra_py.text
          "--target_table"       = "sap_flcb_usd_ssis"
          "--folder_location"    = local.folder_iccbs_ic
          "--input_file_name"    = "sap_flcb_USD.txt"
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
      description       = "ICCBS IC : sap_flcb_PHP.txt → sap_flcb_php_ssis"
      glue_version      = "5.1"
      worker_type       = var.glue_job_configs.worker_type
      number_of_workers = var.glue_job_configs.number_of_workers
      connections       = ["postgres"]
      tags              = { INGESTION_TYPE = "TXT_NUMBERED", PIPELINE = "ICCBS IC" }

      glue_job_command = [
        {
          name            = "glueetl"
          python_version  = "3"
          script_location = "s3://${local.bucket_name}/${local.aws_product_s3_prefix}/${local.s3_script.GlueText}"
        }
      ]

      execution_property = {
        max_concurrent_runs = 3
      }

      default_arguments = merge(
        var.glue_job_configs.default_arguments,
        {
          "--TempDir"            = "s3://${local.bucket_name_storage}/${local.aws_product_s3_prefix}/tmp/"
          "--connection_name"    = "${var.env_prefix}-iccbs_ic-glco-postgres"
          "--extra-py-files"     = local.extra_py.text
          "--target_table"       = "sap_flcb_php_ssis"
          "--folder_location"    = local.folder_iccbs_ic
          "--input_file_name"    = "sap_flcb_PHP.txt"
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
      description       = "ICCBS IC : sap_fdef_USD.txt → sap_fdef_usd_ssis"
      glue_version      = "5.1"
      worker_type       = var.glue_job_configs.worker_type
      number_of_workers = var.glue_job_configs.number_of_workers
      connections       = ["postgres"]
      tags              = { INGESTION_TYPE = "TXT_NUMBERED", PIPELINE = "ICCBS IC" }

      glue_job_command = [
        {
          name            = "glueetl"
          python_version  = "3"
          script_location = "s3://${local.bucket_name}/${local.aws_product_s3_prefix}/${local.s3_script.GlueText}"
        }
      ]

      execution_property = {
        max_concurrent_runs = 3
      }

      default_arguments = merge(
        var.glue_job_configs.default_arguments,
        {
          "--TempDir"            = "s3://${local.bucket_name_storage}/${local.aws_product_s3_prefix}/tmp/"
          "--connection_name"    = "${var.env_prefix}-iccbs_ic-glco-postgres"
          "--extra-py-files"     = local.extra_py.text
          "--target_table"       = "sap_fdef_usd_ssis"
          "--folder_location"    = local.folder_iccbs_ic
          "--input_file_name"    = "sap_fdef_USD.txt"
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
      description       = "ICCBS IC : sap_fdef_PHP.txt → sap_fdef_php_ssis"
      glue_version      = "5.1"
      worker_type       = var.glue_job_configs.worker_type
      number_of_workers = var.glue_job_configs.number_of_workers
      connections       = ["postgres"]
      tags              = { INGESTION_TYPE = "TXT_NUMBERED", PIPELINE = "ICCBS IC" }

      glue_job_command = [
        {
          name            = "glueetl"
          python_version  = "3"
          script_location = "s3://${local.bucket_name}/${local.aws_product_s3_prefix}/${local.s3_script.GlueText}"
        }
      ]

      execution_property = {
        max_concurrent_runs = 3
      }

      default_arguments = merge(
        var.glue_job_configs.default_arguments,
        {
          "--TempDir"            = "s3://${local.bucket_name_storage}/${local.aws_product_s3_prefix}/tmp/"
          "--connection_name"    = "${var.env_prefix}-iccbs_ic-glco-postgres"
          "--extra-py-files"     = local.extra_py.text
          "--target_table"       = "sap_fdef_php_ssis"
          "--folder_location"    = local.folder_iccbs_ic
          "--input_file_name"    = "sap_fdef_PHP.txt"
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
