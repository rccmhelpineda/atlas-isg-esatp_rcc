locals {
  s3_root_eom_bt           = "bss_eom_bayn"
  folder_eom_bt            = "${local.bucket_name_storage}/${local.s3_root_eom_bt}/"
  folder_logs_tran_eom_bt  = "${local.bucket_name_storage}/${local.s3_root_eom_bt}/_logs-transform"
  folder_logs_exp_eom_bt   = "${local.bucket_name_storage}/${local.s3_root_eom_bt}/_logs-export_prepare"
}

module "glue_myb_eom_bt" {
  source = "./modules/aws-glue"

  providers = {
    aws.environment = aws.environment,
    aws.security    = aws.security,
    aws.dr          = aws.dr,
    aws.security_dr = aws.security_dr
  }

  s3_bucket_name = ["storage", "scripts"]
  name           = "myb_eom_bt"
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
      description       = "Mybss_eom_bayan_preload_extract-glue_307 : Extract 307 unbilled adjustments Excel → Aurora"
      glue_version      = "4.0"
      worker_type       = var.glue_job_configs.worker_type
      number_of_workers = var.glue_job_configs.number_of_workers
      connections       = ["postgres"]
      tags              = { INGESTION_TYPE = "EXCEL_COLUMN-HEADED", PIPELINE = "MyBSS EOM Bayan" }

      glue_job_command = [
        {
          name            = "glueetl"
          python_version  = "3"
          script_location = "s3://${local.bucket_name}/${local.aws_product_s3_prefix}/${local.s3_script.GlueSpreadsheet}"
        }
      ]

      execution_property = {
        max_concurrent_runs = 2
      }

      default_arguments = merge(
        var.glue_job_configs.default_arguments,
        {
          "--TempDir"         = "s3://${local.bucket_name_storage}/${local.commons_s3_prefix}/tmp/"
          "--user-jars-first" = "true"
          "--extra-py-files"  = local.extra_py.spreadsheet
          "--extra-jars"      = local.extra_jars
          "--connection_name" = "${var.env_prefix}-myb_eom_bt-glco-postgres"
          "--target_table"    = "sdbtdir2_bayan_dbo.307_Unbilled_Adjustments_Report_B"
          "--target_headers"  = "Customer Type, Customer Sub Type, Primary Subscriber Type, Adjustment Type, Adjustment Date, Adjustment Code/Tax code, Adjustment Reason, Amount, Legal Entity, Currency, Write-Off Activity Indicator"
          "--folder_location" = local.folder_eom_bt
          "--input_file_name" = "307. Unbilled Adjustments Report_B.XLSX"
        }
      )
    },
    {
      name              = "extract_2"
      description       = "Mybss_eom_bayan_preload_extract-glue_317 : Extract 317 unbilled charges Excel → Aurora"
      glue_version      = "4.0"
      worker_type       = var.glue_job_configs.worker_type
      number_of_workers = var.glue_job_configs.number_of_workers
      connections       = ["postgres"]
      tags              = { INGESTION_TYPE = "EXCEL_COLUMN-HEADED", PIPELINE = "MyBSS EOM Bayan" }

      glue_job_command = [
        {
          name            = "glueetl"
          python_version  = "3"
          script_location = "s3://${local.bucket_name}/${local.aws_product_s3_prefix}/${local.s3_script.GlueSpreadsheet}"
        }
      ]

      execution_property = {
        max_concurrent_runs = 2
      }

      default_arguments = merge(
        var.glue_job_configs.default_arguments,
        {
          "--TempDir"         = "s3://${local.bucket_name_storage}/${local.commons_s3_prefix}/tmp/"
          "--user-jars-first" = "true"
          "--extra-py-files"  = local.extra_py.spreadsheet
          "--extra-jars"      = local.extra_jars
          "--connection_name" = "${var.env_prefix}-myb_eom_bt-glco-postgres"
          "--target_table"    = "sdbtdir2_bayan_dbo.317_Unbilled_Charges_B"
          "--target_headers"  = "Customer Type, Customer SubType, Service Type, Revenue Type, Charge Code, Offer ID, Offer Description, Charge Type, Legal Entity, Currency, Amount"
          "--folder_location" = local.folder_eom_bt
          "--input_file_name" = "317. Unbilled Charges Summary Report_B.XLSX"
        }
      )
    },
    {
      name              = "extract_3"
      description       = "Mybss_eom_bayan_preload_extract-glue_324 : Extract 324 unearned MSF Excel → Aurora"
      glue_version      = "4.0"
      worker_type       = var.glue_job_configs.worker_type
      number_of_workers = var.glue_job_configs.number_of_workers
      connections       = ["postgres"]
      tags              = { INGESTION_TYPE = "EXCEL_COLUMN-HEADED_NUMBERED", PIPELINE = "MyBSS EOM Bayan" }

      glue_job_command = [
        {
          name            = "glueetl"
          python_version  = "3"
          script_location = "s3://${local.bucket_name}/${local.aws_product_s3_prefix}/${local.s3_script.GlueSpreadsheet}"
        }
      ]

      execution_property = {
        max_concurrent_runs = 2
      }

      default_arguments = merge(
        var.glue_job_configs.default_arguments,
        {
          "--TempDir"          = "s3://${local.bucket_name_storage}/${local.commons_s3_prefix}/tmp/"
          "--user-jars-first"  = "true"
          "--extra-py-files"   = local.extra_py.spreadsheet
          "--extra-jars"       = local.extra_jars
          "--connection_name"  = "${var.env_prefix}-myb_eom_bt-glco-postgres"
          "--target_table"     = "sdbtdir2_bayan_dbo.324_Unearned_MSF_Summary_Report_B"
          "--target_headers"   = "Customer Type, Customer SubType, Service Type, Revenue Type, Charge Code, Offer ID, Offer Description, Charge Type, Legal Entity, Currency, Amount"
          "--folder_location"  = local.folder_eom_bt
          "--input_file_name"  = "324. Unearned MSF Summary Report_B.XLSX"
          "--row_number_label" = "rownum"
        }
      )
    }
  ]
}
