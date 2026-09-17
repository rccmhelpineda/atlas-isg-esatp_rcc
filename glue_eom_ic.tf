locals {
  s3_root_eom_ic = "bss_eom_inov"
  folder_eom_ic           = "${local.bucket_name_storage}/${local.s3_root_eom_ic}/"
  ffolder_logs_tran_eom_ic = "${local.bucket_name_storage}/${local.s3_root_eom_ic}/_logs-transform"
  fffolder_logs_exp_eom_ic  = "${local.bucket_name_storage}/${local.s3_root_eom_ic}/_logs-export_prepare"
}

module "glue_eom_innove" {
  source = "./modules/aws-glue"

  providers = {
    aws.environment = aws.environment,
    aws.security    = aws.security,
    aws.dr          = aws.dr,
    aws.security_dr = aws.security_dr
  }

  s3_bucket_name     = ["storage","scripts"]

  name = "mybss_ic_eom"

  sns_topic_name = null

  # Catalog DB etl is owned by module.glue_extract (glue_bc_bt.tf).
  glue_database = []

  source_secrets_manager_arn         = var.dbSecret
  source_secrets_manager_name         = var.dbSecretName
  source_secrets_manager_kms_key_arn = "*"

  glue_connections = [
    {
        name            = "postgres"
        description     = "JDBC connection to PostgreSQL database via Secrets Manager"
        connection_type = "JDBC"
        create_source_db_secret = false

        connection_properties = {
          JDBC_CONNECTION_URL = "jdbc:postgresql://${var.dbInstance}:${var.dbPort}/${var.dbName}"
        }

        physical_connection_requirements = [
        {
            availability_zone      = var.glueConnectionAZ_NW1
            subnet_id              = var.glueConnectionSubnetID_NW1
            security_group_id_list = [var.glueConnectionSG_NW1[2]]
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
      description       = "Mybss_eom_inov_preload_extract-glue : Orchestrator: start extract child jobs"
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
        "--job_list"         = "${var.env_prefix}-mybss_ic_eom-gljo-extract_1,${var.env_prefix}-mybss_ic_eom-gljo-extract_2,${var.env_prefix}-mybss_ic_eom-gljo-extract_3,${var.env_prefix}-mybss_ic_eom-gljo-extract_4,${var.env_prefix}-mybss_ic_eom-gljo-extract_5,${var.env_prefix}-mybss_ic_eom-gljo-extract_6,${var.env_prefix}-mybss_ic_eom-gljo-extract_7"
        }
      )
    },

    {
      name              = "extract_1"
      description       = "Mybss_eom_inov_preload_extract-glue_307 : Extract 307 unbilled adjustments Excel → Aurora"
      glue_version      = "4.0"
      worker_type       = var.glue_job_configs.worker_type
      number_of_workers = var.glue_job_configs.number_of_workers
      connections       = ["postgres"]
      tags              = { INGESTION_TYPE = "EXCEL_COLUMN-HEADED" }

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
        "--connection_name"  = "${var.env_prefix}-mybss_ic_eom-glco-postgres"
        "--target_table"     = "sdbtdir2_innove_dbo.307_Unbilled_Adjustments_Report_I"
        "--target_headers"   = "Customer Type, Customer Sub Type, Primary Subscriber Type, Adjustment Type, Adjustment Date, Adjustment Code/Tax code, Adjustment Reason, Amount, Legal Entity, Currency, Write-Off Activity Indicator"
        "--folder_location"  = local.folder_eom_ic
        "--input_file_name"  = "307. Unbilled Adjustments Report_I.xlsx"
      }
      )
    },

    {
      name              = "extract_2"
      description       = "Mybss_eom_inov_preload_extract-glue_317 : Extract 317 unbilled charges Excel → Aurora"
      glue_version      = "4.0"
      worker_type       = var.glue_job_configs.worker_type
      number_of_workers = var.glue_job_configs.number_of_workers
      connections       = ["postgres"]
      tags              = { INGESTION_TYPE = "EXCEL_COLUMN-HEADED" }

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
        "--connection_name"  = "${var.env_prefix}-mybss_ic_eom-glco-postgres"
        "--target_table"     = "sdbtdir2_innove_dbo.317_Unbilled_Charges_I"
        "--target_headers"   = "Customer Type, Customer SubType, Service Type, Revenue Type, Charge Code, Offer ID, Offer Description, Charge Type, Legal Entity, Currency, Amount"
        "--folder_location"  = local.folder_eom_ic
        "--input_file_name"  = "317. Unbilled Charges Summary Report_I.xlsx"
      }
      )
    },

    {
      name              = "extract_3"
      description       = "Mybss_eom_inov_preload_extract-glue_324 : Extract 324 unearned MSF Excel → Aurora"
      glue_version      = "4.0"
      worker_type       = var.glue_job_configs.worker_type
      number_of_workers = var.glue_job_configs.number_of_workers
      connections       = ["postgres"]
      tags              = { INGESTION_TYPE = "EXCEL_COLUMN-HEADED_NUMBERED" }

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
        "--connection_name"  = "${var.env_prefix}-mybss_ic_eom-glco-postgres"
        "--target_table"     = "sdbtdir2_innove_dbo.324_Unearned_MSF_Summary_Report_I"
        "--folder_location"  = local.folder_eom_ic
        "--input_file_name"  = "324. Unearned MSF Summary Report_I.xlsx"
        "--row_number_label" = "rownum"
        "--target_headers"   = "Customer Type, Customer SubType, Service Type, Charge Code, Charge Code Description, Offer Description, Amount, Total Unearned RC, LEGAL ENTITY, CURRENCY"
      }
      )
    },

    {
      name              = "extract_4"
      description       = "Mybss_eom_inov_preload_extract-glue_SAP_airc : Extract SAP airc text → Aurora"
      glue_version      = "5.1"
      worker_type       = var.glue_job_configs.worker_type
      number_of_workers = var.glue_job_configs.number_of_workers
      connections       = ["postgres"]
      tags              = { INGESTION_TYPE = "TXT_NUMBERED" }

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
        "--TempDir"            = "s3://${local.bucket_name_storage}/${local.commons_s3_prefix}/tmp/"
        "--user-jars-first"    = "true"
        "--connection_name"    = "${var.env_prefix}-mybss_ic_eom-glco-postgres"
        "--extra-py-files"     = local.extra_py.text
        "--target_table"       = "sdbtdir2_innove_dbo.sap_airc_i"
        "--folder_location"    = local.folder_eom_ic
        "--input_file_name"    = "sap_airc_I.txt"
        "--delimiter_regex"    = "\\t"
        "--filter_record_type" = "ALL"
        "--expected_columns"   = "30"
        "--col_label"          = "column"
        "--row_number_label"   = "zrownumber"
      }
      )
    },

    {
      name              = "extract_5"
      description       = "Mybss_eom_inov_preload_extract-glue_SAP_aiuc_I : Extract SAP aiuc text → Aurora"
      glue_version      = "5.1"
      worker_type       = var.glue_job_configs.worker_type
      number_of_workers = var.glue_job_configs.number_of_workers
      connections       = ["postgres"]
      tags              = { INGESTION_TYPE = "TXT_NUMBERED" }

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
        "--user-jars-first"    = "true"
        "--connection_name"    = "${var.env_prefix}-mybss_ic_eom-glco-postgres"
        "--extra-py-files"     = local.extra_py.text
        "--target_table"       = "sdbtdir2_innove_dbo.sap_aiuc_i"
        "--folder_location"    = local.folder_eom_ic
        "--input_file_name"    = "sap_aiuc_I.txt"
        "--delimiter_regex"    = "\\t"
        "--filter_record_type" = "ALL"
        "--expected_columns"   = "30"
        "--col_label"          = "column"
        "--row_number_label"   = "zrownumber"
      }
      )
    },

    {
      name              = "extract_6"
      description       = "Mybss_eom_inov_preload_extract-glue_SAP_glunbilled_I : Extract SAP glunbilled text → Aurora"
      glue_version      = "5.1"
      worker_type       = var.glue_job_configs.worker_type
      number_of_workers = var.glue_job_configs.number_of_workers
      connections       = ["postgres"]
      tags              = { INGESTION_TYPE = "TXT_NUMBERED" }

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
        "--user-jars-first"    = "true"
        "--connection_name"    = "${var.env_prefix}-mybss_ic_eom-glco-postgres"
        "--extra-py-files"     = local.extra_py.text
        "--target_table"       = "sdbtdir2_innove_dbo.sap_glunbilled_i"
        "--folder_location"    = local.folder_eom_ic
        "--input_file_name"    = "sap_glunbilled_I.txt"
        "--delimiter_regex"    = "\\t"
        "--filter_record_type" = "ALL"
        "--expected_columns"   = "30"
        "--col_label"          = "column"
        "--row_number_label"   = "zrownumber"
      }
      )
    },

    {
      name              = "extract_7"
      description       = "Mybss_eom_inov_preload_extract-glue_SAP_glunbilled_unconf_I : Extract SAP glunbilled unconfirmed text → Aurora"
      glue_version      = "5.1"
      worker_type       = var.glue_job_configs.worker_type
      number_of_workers = var.glue_job_configs.number_of_workers
      connections       = ["postgres"]
      tags              = { INGESTION_TYPE = "TXT_NUMBERED" }

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
        "--user-jars-first"    = "true"
        "--connection_name"    = "${var.env_prefix}-mybss_ic_eom-glco-postgres"
        "--extra-py-files"     = local.extra_py.text
        "--target_table"       = "sdbtdir2_innove_dbo.sap_glunbilled_unconf_i"
        "--folder_location"    = local.folder_eom_ic
        "--input_file_name"    = "sap_glunbilled_unconf_I.txt"
        "--delimiter_regex"    = "\\t"
        "--filter_record_type" = "ALL"
        "--expected_columns"   = "30"
        "--col_label"          = "column"
        "--row_number_label"   = "zrownumber"
      }
      )
    },

    {
      name              = "sap_preload"
      description       = "Mybss_eom_inov_preload_sap-glue : Call Aurora SP sp_mybss_innove_eom_preload_000_loadsaptables"
      glue_version      = "5.1"
      worker_type       = var.glue_job_configs.worker_type
      number_of_workers = var.glue_job_configs.number_of_workers
      connections       = ["postgres"]
      tags              = { PIPELINE = "MyBSS EOM Innove" }

      glue_job_command = [
        {
          name            = "glueetl"
          python_version  = "3"
          script_location = "s3://${local.bucket_name}/${local.aws_product_s3_prefix}/${local.s3_script.GlueDbSpCaller}"
        }
      ]

      execution_property = {
        max_concurrent_runs = 2
      }

      default_arguments = merge(
        var.glue_job_configs.default_arguments,
      {
        "--TempDir"         = "s3://${local.bucket_name_storage}/${local.aws_product_s3_prefix}/tmp/"
        "--CONN_DB_TO"      = "${var.env_prefix}-mybss_ic_eom-glco-postgres"
        "--extra-py-files"  = local.extra_py.dbsp
        "--extra-jars"      = null
        "--FOLDER_LOCATION" = local.folder_eom_ic
        "--PROCEDURE_NAME"  = "dswtdir2_innove_dbo.sp_mybss_innove_eom_preload_000_loadsaptables"
      }
      )
    },

    {
      name              = "transform_1"
      description       = "Mybss_eom_inov_preload_unearned_tran-glue : Call DP2 unearned transform SP"
      glue_version      = "5.1"
      worker_type       = var.glue_job_configs.worker_type
      number_of_workers = var.glue_job_configs.number_of_workers
      connections       = ["postgres"]
      tags              = { PIPELINE = "MyBSS EOM Innove" }

      glue_job_command = [
        {
          name            = "glueetl"
          python_version  = "3"
          script_location = "s3://${local.bucket_name}/${local.aws_product_s3_prefix}/${local.s3_script.GlueDbSpCaller}"
        }
      ]

      execution_property = {
        max_concurrent_runs = 2
      }

      default_arguments = merge(
        var.glue_job_configs.default_arguments,
      {
        "--TempDir"         = "s3://${local.bucket_name_storage}/${local.aws_product_s3_prefix}/tmp/"
        "--CONN_DB_TO"      = "${var.env_prefix}-mybss_ic_eom-glco-postgres"
        "--extra-py-files"  = local.extra_py.dbsp
        "--extra-jars"      = null
        "--FOLDER_LOCATION" = local.ffolder_logs_tran_eom_ic
        "--PROCEDURE_NAME"  = "dswtdir2_innove_dbo.sp_mybss_innove_eom_preload_unearned_msf_transform_dummy"
      }
      )
    },

    {
      name              = "export_1a"
      description       = "Mybss_eom_inov_preload_unearned_export_prepare-glue : Call DP2 unearned report prepare SP"
      glue_version      = "5.1"
      worker_type       = var.glue_job_configs.worker_type
      number_of_workers = var.glue_job_configs.number_of_workers
      connections       = ["postgres"]
      tags              = { PIPELINE = "MyBSS EOM Innove" }

      glue_job_command = [
        {
          name            = "glueetl"
          python_version  = "3"
          script_location = "s3://${local.bucket_name}/${local.aws_product_s3_prefix}/${local.s3_script.GlueDbSpCaller}"
        }
      ]

      execution_property = {
        max_concurrent_runs = 2
      }

      default_arguments = merge(
        var.glue_job_configs.default_arguments,
      {
        "--TempDir"          = "s3://${local.bucket_name_storage}/${local.aws_product_s3_prefix}/tmp/"
        "--CONN_DB_TO"      = "${var.env_prefix}-mybss_ic_eom-glco-postgres"
        "--extra-py-files"  = local.extra_py.dbsp
        "--extra-jars"      = null
        "--FOLDER_LOCATION" = local.fffolder_logs_exp_eom_ic
        "--PROCEDURE_NAME"  = "dswtdir2_innove_dbo.sp_mybss_innove_eom_preload_unearned_msf_report_prepare_dummy"
      }
      )
    },

    {
      name              = "export_1b"
      description       = "Mybss_eom_inov_preload_unearned_export-glue : Export DP2 unearned load file"
      glue_version      = "5.1"
      worker_type       = var.glue_job_configs.worker_type
      number_of_workers = var.glue_job_configs.number_of_workers
      connections       = ["postgres"]
      execution_class   = "STANDARD"
      tags              = { PIPELINE = "MyBSS EOM Innove" }

      glue_job_command = [
        {
          name            = "glueetl"
          python_version  = "3"
          script_location = "s3://${local.bucket_name}/${local.aws_product_s3_prefix}/${local.s3_script.GlueDbSpCaller}"
        }
      ]

      execution_property = {
        max_concurrent_runs = 2
      }

      default_arguments = merge(
        var.glue_job_configs.default_arguments,
      {
        "--TempDir"          = "s3://${local.bucket_name_storage}/${local.aws_product_s3_prefix}/tmp/"
        "--CONN_DB_TO"          = "${var.env_prefix}-mybss_ic_eom-glco-postgres"
        "--extra-py-files"      = local.extra_py.dbsp_export
        "--extra-jars"          = null
        "--FOLDER_LOCATION"     = local.folder_eom_ic
        "--PROCEDURE_NAME"      = "dswtdir2_innove_dbo.sp_mybss_innove_eom_preload_unearned_msf_export_new_dummy"
        "--EXPORT"              = "txInnove_Unearned_MSF_LoadFileSel.txt"
        "--LOAD_TABLE"          = "dswtdir2_innove_dbo.txinnove_unearned_msf_loadfilesel_export"
        "--TARGET_FOLDER"       = "outbound/"
      }
      )
    },

    {
      name              = "transform_2"
      description       = "Mybss_eom_inov_preload_unbilled_charges_tran-glue : Call DP3 unbilled charges transform SP"
      glue_version      = "5.1"
      worker_type       = var.glue_job_configs.worker_type
      number_of_workers = var.glue_job_configs.number_of_workers
      connections       = ["postgres"]
      tags              = { PIPELINE = "MyBSS EOM Innove" }

      glue_job_command = [
        {
          name            = "glueetl"
          python_version  = "3"
          script_location = "s3://${local.bucket_name}/${local.aws_product_s3_prefix}/${local.s3_script.GlueDbSpCaller}"
        }
      ]

      execution_property = {
        max_concurrent_runs = 2
      }

      default_arguments = merge(
        var.glue_job_configs.default_arguments,
      {
        "--TempDir"          = "s3://${local.bucket_name_storage}/${local.aws_product_s3_prefix}/tmp/"
        "--CONN_DB_TO"      = "${var.env_prefix}-mybss_ic_eom-glco-postgres"
        "--extra-py-files"  = local.extra_py.dbsp
        "--extra-jars"      = null
        "--FOLDER_LOCATION" = local.ffolder_logs_tran_eom_ic
        "--PROCEDURE_NAME"  = "dswtdir2_innove_dbo.sp_mybss_innove_eom_preload_unbilled_char_transform_dummy"

      }
      )
    },

    {
      name              = "export_2a"
      description       = "Mybss_eom_inov_preload_unbilled_charges_export_prepare-glue : Call DP3 unbilled charges report prepare SP"
      glue_version      = "5.1"
      worker_type       = var.glue_job_configs.worker_type
      number_of_workers = var.glue_job_configs.number_of_workers
      connections       = ["postgres"]
      tags              = { PIPELINE = "MyBSS EOM Innove" }

      glue_job_command = [
        {
          name            = "glueetl"
          python_version  = "3"
          script_location = "s3://${local.bucket_name}/${local.aws_product_s3_prefix}/${local.s3_script.GlueDbSpCaller}"
        }
      ]

      execution_property = {
        max_concurrent_runs = 2
      }

      default_arguments = merge(
        var.glue_job_configs.default_arguments,
      {
        "--TempDir"          = "s3://${local.bucket_name_storage}/${local.aws_product_s3_prefix}/tmp/"
        "--CONN_DB_TO"      = "${var.env_prefix}-mybss_ic_eom-glco-postgres"
        "--extra-py-files"  = local.extra_py.dbsp
        "--extra-jars"      = null
        "--FOLDER_LOCATION" = local.fffolder_logs_exp_eom_ic
        "--PROCEDURE_NAME"  = "dswtdir2_innove_dbo.sp_mybss_innove_eom_preload_unbilled_char_report_prepare_dummy"
      }
      )
    },

    {
      name              = "export_2b"
      description       = "Mybss_eom_inov_preload_unbilled_charges_export-glue : Export DP3 unbilled charges file"
      glue_version      = "5.1"
      worker_type       = var.glue_job_configs.worker_type
      number_of_workers = var.glue_job_configs.number_of_workers
      connections       = ["postgres"]
      execution_class   = "STANDARD"
      tags              = { PIPELINE = "MyBSS EOM Innove" }

      glue_job_command = [
        {
          name            = "glueetl"
          python_version  = "3"
          script_location = "s3://${local.bucket_name}/${local.aws_product_s3_prefix}/${local.s3_script.GlueDbSpCaller}"
        }
      ]

      execution_property = {
        max_concurrent_runs = 2
      }

      default_arguments = merge(
        var.glue_job_configs.default_arguments,
      {
        "--TempDir"          = "s3://${local.bucket_name_storage}/${local.aws_product_s3_prefix}/tmp/"
        "--CONN_DB_TO"          = "${var.env_prefix}-mybss_ic_eom-glco-postgres"
        "--extra-py-files"      = local.extra_py.dbsp_export
        "--extra-jars"          = null
        "--FOLDER_LOCATION"     = local.folder_eom_ic
        "--PROCEDURE_NAME"      = "dswtdir2_innove_dbo.sp_mybss_innove_eom_preload_unbilled_char_export_new_dummy"
        "--EXPORT"              = "txInnove_Unbilled_Char_LoadFileSel.txt"
        "--LOAD_TABLE"          = "dswtdir2_innove_dbo.txinnove_unbilled_char_loadfilesel_export"
        "--TARGET_FOLDER"       = "outbound/"
      }
      )
    },

    {
      name              = "transform_3"
      description       = "Mybss_eom_inov_preload_unbilled_adjustments_tran-glue : Call DP4 unbilled adjustments transform SP"
      glue_version      = "5.1"
      worker_type       = var.glue_job_configs.worker_type
      number_of_workers = var.glue_job_configs.number_of_workers
      connections       = ["postgres"]
      tags              = { PIPELINE = "MyBSS EOM Innove" }

      glue_job_command = [
        {
          name            = "glueetl"
          python_version  = "3"
          script_location = "s3://${local.bucket_name}/${local.aws_product_s3_prefix}/${local.s3_script.GlueDbSpCaller}"
        }
      ]

      execution_property = {
        max_concurrent_runs = 2
      }

      default_arguments = merge(
        var.glue_job_configs.default_arguments,
      {
        "--TempDir"         = "s3://${local.bucket_name_storage}/${local.aws_product_s3_prefix}/tmp/"
        "--CONN_DB_TO"      = "${var.env_prefix}-mybss_ic_eom-glco-postgres"
        "--extra-py-files"  = local.extra_py.dbsp
        "--extra-jars"      = null
        "--FOLDER_LOCATION" = local.ffolder_logs_tran_eom_ic
        "--PROCEDURE_NAME"  = "dswtdir2_innove_dbo.sp_mybss_innove_eom_preload_unbilled_adj_transform_dummy"
      }
      )
    },

    {
      name              = "export_3a"
      description       = "Mybss_eom_inov_preload_unbilled_adjustments_export_prepare-glue : Call DP4 unbilled adjustments report prepare SP"
      glue_version      = "5.1"
      worker_type       = var.glue_job_configs.worker_type
      number_of_workers = var.glue_job_configs.number_of_workers
      connections       = ["postgres"]
      tags              = { PIPELINE = "MyBSS EOM Innove" }

      glue_job_command = [
        {
          name            = "glueetl"
          python_version  = "3"
          script_location = "s3://${local.bucket_name}/${local.aws_product_s3_prefix}/${local.s3_script.GlueDbSpCaller}"
        }
      ]

      execution_property = {
        max_concurrent_runs = 2
      }

      default_arguments = merge(
        var.glue_job_configs.default_arguments,
      {
        "--TempDir"          = "s3://${local.bucket_name_storage}/${local.aws_product_s3_prefix}/tmp/"
        "--CONN_DB_TO"      = "${var.env_prefix}-mybss_ic_eom-glco-postgres"
        "--extra-py-files"  = local.extra_py.dbsp
        "--extra-jars"      = null
        "--FOLDER_LOCATION" = local.fffolder_logs_exp_eom_ic
        "--PROCEDURE_NAME"  = "dswtdir2_innove_dbo.sp_mybss_innove_eom_preload_unbilled_adj_report_prepare_dummy"
      }
      )
    },

    {
      name              = "export_3b"
      description       = "Mybss_eom_inov_preload_unbilled_adjustments_export-glue : Export DP4 unbilled adjustments file"
      glue_version      = "5.1"
      worker_type       = var.glue_job_configs.worker_type
      number_of_workers = var.glue_job_configs.number_of_workers
      connections       = ["postgres"]
      execution_class   = "STANDARD"
      tags              = { PIPELINE = "MyBSS EOM Innove" }

      glue_job_command = [
        {
          name            = "glueetl"
          python_version  = "3"
          script_location = "s3://${local.bucket_name}/${local.aws_product_s3_prefix}/${local.s3_script.GlueDbSpCaller}"
        }
      ]

      execution_property = {
        max_concurrent_runs = 2
      }

      default_arguments = merge(
        var.glue_job_configs.default_arguments,
      {
        "--TempDir"          = "s3://${local.bucket_name_storage}/${local.aws_product_s3_prefix}/tmp/"
        "--CONN_DB_TO"          = "${var.env_prefix}-mybss_ic_eom-glco-postgres"
        "--extra-py-files"      = local.extra_py.dbsp_export
        "--extra-jars"          = null
        "--FOLDER_LOCATION"     = local.folder_eom_ic
        "--PROCEDURE_NAME"      = "dswtdir2_innove_dbo.sp_mybss_innove_eom_preload_unbilled_adj_export_new_dummy"
        "--EXPORT"              = "txInnove_Unbilled_Adj_LoadFileSel.txt"
        "--LOAD_TABLE"          = "dswtdir2_innove_dbo.txinnove_unbilled_adj_loadfilesel_export"
        "--TARGET_FOLDER"       = "outbound/"
      }
      )
    }

  ]

}
