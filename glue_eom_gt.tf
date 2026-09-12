locals {
  pipeline_s3_root_eom = "bss_eom_glob"
  folder_eom           = "${local.bucket_name_storage}/${local.pipeline_s3_root_eom}/"
  folder_logs_tran_eom = "${local.bucket_name_storage}/${local.pipeline_s3_root_eom}/_logs-transform"
  folder_logs_exp_eom  = "${local.bucket_name_storage}/${local.pipeline_s3_root_eom}/_logs-export_prepare"
}

module "glue_eom_globe" {
  # source = "globe.pe.jfrog.io/hmd-terraform-local__service/aws-glue/aws"
  source = "./modules/aws-glue"
  # version = "~>1.5.1"

  providers = {
    aws.environment = aws.environment,
    aws.security    = aws.security,
    aws.dr          = aws.dr,
    aws.security_dr = aws.security_dr
  }

  s3_bucket_name     = ["storage","scripts"]

  name = "mybss_gt_eom"

  sns_topic_name = null

  glue_database = [
    {
        name = "etl"
    }
  ]

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
          JDBC_CONNECTION_URL = "jdbc:postgresql://${var.dbInstance}:1769/${var.dbName}"
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
      description       = "Mybss_eom_glob_preload_extract-glue : Orchestrator: start extract child jobs + SFN for Unconfirmed Advance MSF"
      glue_version      = "5.1"
      worker_type       = "G.1X"
      number_of_workers = 5
      tags              = { PIPELINE = "MyBSS EOM Globe" }

      glue_job_command  = [
        {
          name            = "glueetl"
          python_version  = "3"
          script_location = "s3://${local.bucket_name}/${local.aws_product_s3_prefix}/${local.s3_script.GluePipelinesOrchestrator}"
        }
      ]

      execution_property = {
        max_concurrent_runs = 3
      }

      default_arguments = merge(
        var.glue_job_configs.default_arguments,
        {
        "--TempDir"             = "s3://${local.bucket_name_storage}/${local.commons_s3_prefix}/tmp/"
        "--extra-py-files"      = local.extra_py.orchestrator
        "--job_list"         = "isg-esatp-dv-mybss_gt_eom-gljo-extract_1,isg-esatp-dv-mybss_gt_eom-gljo-extract_2,isg-esatp-dv-mybss_gt_eom-gljo-extract_3,isg-esatp-dv-mybss_gt_eom-gljo-extract_4,isg-esatp-dv-mybss_gt_eom-gljo-extract_5,isg-esatp-dv-mybss_gt_eom-gljo-extract_6,isg-esatp-dv-mybss_gt_eom-gljo-extract_7"
        "--sfn_list"         = "arn:aws:states:us-east-1:979437352248:stateMachine:bss_eom_glob_preload_extract-state_machine_Unconfirmed_Advance_MSF"
        }
      )
    },

    {
      name              = "extract_1"
      description       = "Mybss_eom_glob_preload_extract-glue_307 : Extract 307 unbilled adjustments Excel → Aurora"
      glue_version      = "4.0"
      worker_type       = "G.1X"
      number_of_workers = 10
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
        max_concurrent_runs = 3
      }

      default_arguments = merge(
        var.glue_job_configs.default_arguments,
      {
        "--TempDir"             = "s3://${local.bucket_name_storage}/${local.commons_s3_prefix}/tmp/"
        "--user-jars-first"  = "true"
        "--extra-py-files"   = local.extra_py.spreadsheet
        "--extra-jars"       = local.extra_jars
        "--connection_name"  = "isg-esatp-dv-mybss_gt_eom-glco-postgres"
        "--target_table"     = "sdbtdir2_globe_dbo.307_Unbilled_Adjustments_Report_G"
        "--target_headers"   = "Customer Type, Customer Sub Type, Primary Subscriber Type, Adjustment Type, Adjustment Date, Adjustment Code/Tax code, Adjustment Reason, Amount, Legal Entity, Currency, Write-Off Activity Indicator"
        "--row_number_label" = "zrownumber"
        "--folder_location"  = local.folder_eom
        "--input_file_name"  = "307. Unbilled Adjustments Report_G.xlsx"
      }
      )
    },

    {
      name              = "extract_2"
      description       = "Mybss_eom_glob_preload_extract-glue_317 : Extract 317 unbilled charges Excel → Aurora"
      glue_version      = "4.0"
      worker_type       = "G.1X"
      number_of_workers = 10
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
        max_concurrent_runs = 3
      }

      default_arguments = merge(
        var.glue_job_configs.default_arguments,
      {
        "--TempDir"             = "s3://${local.bucket_name_storage}/${local.commons_s3_prefix}/tmp/"
        "--user-jars-first"  = "true"
        "--extra-py-files"   = local.extra_py.spreadsheet
        "--extra-jars"       = local.extra_jars
        "--connection_name"  = "isg-esatp-dv-mybss_gt_eom-glco-postgres"
        "--target_table"     = "sdbtdir2_globe_dbo.317_Unbilled_Charges_Summary_Report_G"
        "--target_headers"   = "Customer Type, Customer SubType, Service Type, Revenue Type, Charge Code, Offer ID, Offer Description, Charge Type, Legal Entity, Currency, Amount"
        "--folder_location"  = local.folder_eom
        "--input_file_name"  = "317. Unbilled Charges Summary Report_G.XLSX"
      }
      )
    },

    {
      name              = "extract_3"
      description       = "Mybss_eom_glob_preload_extract-glue_324 : Extract 324 unearned MSF Excel → Aurora"
      glue_version      = "4.0"
      worker_type       = "G.1X"
      number_of_workers = 10
      connections       = ["postgres"]
      tags              = { INGESTION_TYPE = "EXCEL_STRAIGHT-FLAT" }

      glue_job_command = [
        {
          name            = "glueetl"
          python_version  = "3"
          script_location = "s3://${local.bucket_name}/${local.aws_product_s3_prefix}/${local.s3_script.GlueSpreadsheet}"
        }
      ]

      execution_property = {
        max_concurrent_runs = 3
      }

      default_arguments = merge(
        var.glue_job_configs.default_arguments,
      {
        "--TempDir"             = "s3://${local.bucket_name_storage}/${local.commons_s3_prefix}/tmp/"
        "--user-jars-first"  = "true"
        "--extra-py-files"   = local.extra_py.spreadsheet
        "--extra-jars"       = local.extra_jars
        "--connection_name"  = "postgres"
        "--target_table"     = "sdbtdir2_globe_dbo.324_Unearned_MSF"
        "--folder_location"  = local.folder_eom
        "--input_file_name"  = "324. Unearned MSF Summary Report_G.xlsx"
      }
      )
    },

    {
      name              = "extract_4"
      description       = "Mybss_eom_glob_preload_extract-glue_SAP_airc : Extract SAP airc text → Aurora"
      glue_version      = "5.1"
      worker_type       = "G.1X"
      number_of_workers = 10
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
        max_concurrent_runs = 3
      }

      default_arguments = merge(
        var.glue_job_configs.default_arguments,
      {
        "--TempDir"             = "s3://${local.bucket_name_storage}/${local.commons_s3_prefix}/tmp/"
        "--user-jars-first"    = "true"
        "--connection_name"    = "isg-esatp-dv-mybss_gt_eom-glco-postgres"
        "--extra-py-files"     = local.extra_py.text
        "--target_table"       = "sdbtdir2_globe_dbo.sap_airc"
        "--folder_location"    = local.folder_eom
        "--input_file_name"    = "sap_airc_G.txt"
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
      description       = "Mybss_eom_glob_preload_extract-glue_SAP_aiuc_G : Extract SAP aiuc text → Aurora"
      glue_version      = "5.1"
      worker_type       = "G.1X"
      number_of_workers = 10
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
        max_concurrent_runs = 3
      }

      default_arguments = merge(
        var.glue_job_configs.default_arguments,
      {
        "--TempDir"            = "s3://${local.bucket_name}/${local.aws_product_s3_prefix}/tmp/"
        "--user-jars-first"    = "true"
        "--connection_name"    = "isg-esatp-dv-mybss_gt_eom-glco-postgres"
        "--extra-py-files"     = local.extra_py.text
        "--target_table"       = "sdbtdir2_globe_dbo.sap_aiuc_g"
        "--folder_location"    = local.folder_eom
        "--input_file_name"    = "sap_aiuc_G.txt"
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
      description       = "Mybss_eom_glob_preload_extract-glue_SAP_glunbilled_G : Extract SAP glunbilled text → Aurora"
      glue_version      = "5.1"
      worker_type       = "G.1X"
      number_of_workers = 10
      connections       = ["postgres"]
      tags              = { INGESTION_TYPE = "TXT" }

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
        "--TempDir"            = "s3://${local.bucket_name}/${local.aws_product_s3_prefix}/tmp/"
        "--user-jars-first"    = "true"
        "--connection_name"    = "isg-esatp-dv-mybss_gt_eom-glco-postgres"
        "--extra-py-files"     = local.extra_py.text
        "--target_table"       = "sdbtdir2_globe_dbo.sap_glunbilled_g"
        "--folder_location"    = local.folder_eom
        "--input_file_name"    = "sap_glunbilled_G.txt"
        "--delimiter_regex"    = "\\t"
        "--filter_record_type" = "ALL"
        "--expected_columns"   = "30"
        "--col_label"          = "column"
      }
      )
    },

    {
      name              = "extract_7"
      description       = "Mybss_eom_glob_preload_extract-glue_SAP_glunbilled_unconf_G : Extract SAP glunbilled unconfirmed text → Aurora"
      glue_version      = "5.1"
      worker_type       = "G.1X"
      number_of_workers = 10
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
        max_concurrent_runs = 3
      }

      default_arguments = merge(
        var.glue_job_configs.default_arguments,
      {
        "--TempDir"            = "s3://${local.bucket_name}/${local.aws_product_s3_prefix}/tmp/"
        "--user-jars-first"    = "true"
        "--connection_name"    = "isg-esatp-dv-mybss_gt_eom-glco-postgres"
        "--extra-py-files"     = local.extra_py.text
        "--target_table"       = "sdbtdir2_globe_dbo.sap_glunbilled_g"
        "--folder_location"    = local.folder_eom
        "--input_file_name"    = "sap_glunbilled_unconf_G.txt"
        "--delimiter_regex"    = "\\t"
        "--filter_record_type" = "ALL"
        "--expected_columns"   = "30"
        "--col_label"          = "column"
        "--row_number_label"   = "zrownumber"
      }
      )
    },

    {
      name              = "extract_8"
      description       = "Mybss_eom_glob_preload_extract-glue_Unconfirmed_Advanced_MSF_Charges : Extract MSF charges Excel → Aurora"
      glue_version      = "4.0"
      worker_type       = "G.1X"
      number_of_workers = 10
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
        max_concurrent_runs = 3
      }

      default_arguments = merge(
        var.glue_job_configs.default_arguments,
      {
        "--TempDir"            = "s3://${local.bucket_name}/${local.aws_product_s3_prefix}/tmp/"
        "--user-jars-first"  = "true"
        "--extra-py-files"   = local.extra_py.spreadsheet
        "--extra-jars"       = local.extra_jars
        "--connection_name"  = "isg-esatp-dv-mybss_gt_eom-glco-postgres"
        "--target_table"     = "sdbtdir2_globe_dbo.dp5_unconfirmed_advance_msf_header"
        "--folder_location"  = local.folder_eom
        "--input_file_name"  = "Unconfirmed Advanced MSF Charges Summary Report - Monthly.XLSX"
        "--row_number_label" = "zrownumber"
        "--target_headers"   = "Customer Type, Service Type, Revenue Type, Charge Code, Offer ID, Offer Description, Charge Type, Amount"
      }
      )
    },

    {
      name              = "extract_9"
      description       = "Mybss_eom_glob_preload_extract-glue_Unconfirmed_Advanced_MSF_header : Special MSFp2 standalone script for DP5 header processing"
      glue_version      = "5.1"
      worker_type       = "G.1X"
      number_of_workers = 10
      connections       = ["postgres"]
      tags              = { INGESTION_TYPE = "SPECIAL_DP5_Unconfirmed_Advance_MSF_header" }

      glue_job_command = [
        {
          name            = "glueetl"
          python_version  = "3"
          script_location = "s3://${local.bucket_name}/${local.aws_product_s3_prefix}/core/GlueMyBssEomUnconfirmedAdvanceMSFp2.py"
        }
      ]

      execution_property = {
        max_concurrent_runs = 3
      }

      default_arguments = merge(
        var.glue_job_configs.default_arguments,
      {
        "--TempDir"            = "s3://${local.bucket_name}/${local.aws_product_s3_prefix}/tmp/"
        "--connection_name"  = "isg-esatp-dv-mybss_gt_eom-glco-postgres"
        "--extra-py-files"   = join(",", [
          "s3://${local.bucket_name}/${local.aws_product_s3_prefix}/${local.commons_s3_prefix}/artifacts/et_xmlfile-1.1.0-py3-none-any.whl",
          "s3://${local.bucket_name}/${local.aws_product_s3_prefix}/${local.commons_s3_prefix}/artifacts/openpyxl-3.1.2-py2.py3-none-any.whl",
          "s3://${local.bucket_name}/${local.py.Utils}",
          "s3://${local.bucket_name}/${local.py.UtilsAWS}",
          "s3://${local.bucket_name}/${local.py.CustomDbConnLibs}",
          "s3://${local.bucket_name}/${local.py.CustomErrorLibs}",
        ])
        "--target_table"     = "sdbtdir2_globe_dbo.dp5_unconfirmed_advance_msf_header"
        "--folder_location"  = local.folder_eom
        "--input_file_name"  = "Unconfirmed Advanced MSF Charges Summary Report - Monthly.XLSX"
      }
      )
    },

    {
      name              = "sap_preload"
      description       = "Mybss_eom_glob_preload_sap-glue : Call Aurora SP sp_mybss_globe_eom_preload_000_loadsaptables"
      glue_version      = "5.1"
      worker_type       = "G.1X"
      number_of_workers = 10
      connections       = ["postgres"]
      tags              = { PIPELINE = "MyBSS EOM Globe" }

      glue_job_command = [
        {
          name            = "glueetl"
          python_version  = "3"
          script_location = "s3://${local.bucket_name}/${local.aws_product_s3_prefix}/${local.s3_script.GlueDbSpCaller}"
        }
      ]

      execution_property = {
        max_concurrent_runs = 3
      }

      default_arguments = merge(
        var.glue_job_configs.default_arguments,
      {
        "--TempDir"            = "s3://${local.bucket_name}/${local.aws_product_s3_prefix}/tmp/"
        "--CONN_DB_TO"      = "isg-esatp-dv-mybss_gt_eom-glco-postgres"
        "--extra-py-files"  = local.extra_py.dbsp
        "--extra-jars"      = null
        "--FOLDER_LOCATION" = local.folder_eom
        "--PROCEDURE_NAME"  = "dswtdir2_globe_dbo.sp_mybss_globe_eom_preload_000_loadsaptables"
      }
      )
    },

    {
      name              = "transform_1"
      description       = "Mybss_eom_glob_preload_unearned_tran-glue : Call DP2 unearned transform SP"
      glue_version      = "5.1"
      worker_type       = "G.1X"
      number_of_workers = 10
      connections       = ["postgres"]
      tags              = { PIPELINE = "MyBSS EOM Globe" }

      glue_job_command = [
        {
          name            = "glueetl"
          python_version  = "3"
          script_location = "s3://${local.bucket_name}/${local.aws_product_s3_prefix}/${local.s3_script.GlueDbSpCaller}"
        }
      ]

      execution_property = {
        max_concurrent_runs = 3
      }

      default_arguments = merge(
        var.glue_job_configs.default_arguments,
      {
        "--TempDir"          = "s3://${local.bucket_name}/${local.aws_product_s3_prefix}/tmp/"
        "--CONN_DB_TO"      = "isg-esatp-dv-mybss_gt_eom-glco-postgres"
        "--extra-py-files"  = local.extra_py.dbsp
        "--extra-jars"      = null
        "--FOLDER_LOCATION" = local.folder_logs_tran_eom
        "--PROCEDURE_NAME"  = "dswtdir2_globe_dbo.sp_mybss_globe_eom_preload_dp2_transform_dummy"
        "--SP_PARAMS"          = "YES"

      }
      )
    },

    {
      name              = "export_1a"
      description       = "Mybss_eom_glob_preload_unearned_export_prepare-glue : Call DP2 unearned report prepare SP"
      glue_version      = "5.1"
      worker_type       = "G.1X"
      number_of_workers = 10
      connections       = ["postgres"]
      tags              = { PIPELINE = "MyBSS EOM Globe" }

      glue_job_command = [
        {
          name            = "glueetl"
          python_version  = "3"
          script_location = "s3://${local.bucket_name}/${local.aws_product_s3_prefix}/${local.s3_script.GlueDbSpCaller}"
        }
      ]

      execution_property = {
        max_concurrent_runs = 3
      }

      default_arguments = merge(
        var.glue_job_configs.default_arguments,
      {
        "--TempDir"          = "s3://${local.bucket_name}/${local.aws_product_s3_prefix}/tmp/"
        "--CONN_DB_TO"      = "isg-esatp-dv-mybss_gt_eom-glco-postgres"
        "--extra-py-files"  = local.extra_py.dbsp
        "--extra-jars"      = null
        "--FOLDER_LOCATION" = local.folder_logs_exp_eom
        "--PROCEDURE_NAME"  = "dswtdir2_globe_dbo.sp_mybss_globe_eom_preload_dp2_report_prepare_dummy"
      }
      )
    },

    {
      name              = "export_1b"
      description       = "Mybss_eom_glob_preload_unearned_export-glue : Export DP2 unearned load file"
      glue_version      = "5.1"
      worker_type       = "G.1X"
      number_of_workers = 10
      connections       = ["postgres"]
      execution_class   = "STANDARD"
      tags              = { PIPELINE = "MyBSS EOM Globe" }

      glue_job_command = [
        {
          name            = "glueetl"
          python_version  = "3"
          script_location = "s3://${local.bucket_name}/${local.aws_product_s3_prefix}/${local.s3_script.GlueDbSpCaller}"
        }
      ]

      execution_property = {
        max_concurrent_runs = 3
      }

      default_arguments = merge(
        var.glue_job_configs.default_arguments,
      {
        "--TempDir"          = "s3://${local.bucket_name}/${local.aws_product_s3_prefix}/tmp/"
        "--CONN_DB_TO"          = "isg-esatp-dv-mybss_gt_eom-glco-postgres"
        "--extra-py-files"      = local.extra_py.dbsp_export
        "--extra-jars"          = null
        "--FOLDER_LOCATION"     = local.folder_eom
        "--PROCEDURE_NAME"      = "dswtdir2_globe_dbo.sp_mybss_globe_eom_preload_dp2_export_new_dummy"
        "--EXPORT"              = "txGlobe_DP2_Unearned_LoadFileSel.txt"
        "--LOAD_TABLE"          = "dswtdir2_globe_dbo.tvglobe_dp2_unearned_loadfilesel_export"
        "--TARGET_FOLDER"       = "outbound/"
      }
      )
    },

    {
      name              = "transform_2"
      description       = "Mybss_eom_glob_preload_unbilled_charges_tran-glue : Call DP3 unbilled charges transform SP"
      glue_version      = "5.1"
      worker_type       = "G.1X"
      number_of_workers = 10
      connections       = ["postgres"]
      tags              = { PIPELINE = "MyBSS EOM Globe" }

      glue_job_command = [
        {
          name            = "glueetl"
          python_version  = "3"
          script_location = "s3://${local.bucket_name}/${local.aws_product_s3_prefix}/${local.s3_script.GlueDbSpCaller}"
        }
      ]

      execution_property = {
        max_concurrent_runs = 3
      }

      default_arguments = merge(
        var.glue_job_configs.default_arguments,
      {
        "--TempDir"          = "s3://${local.bucket_name}/${local.aws_product_s3_prefix}/tmp/"
        "--CONN_DB_TO"      = "isg-esatp-dv-mybss_gt_eom-glco-postgres"
        "--extra-py-files"  = local.extra_py.dbsp
        "--extra-jars"      = null
        "--FOLDER_LOCATION" = local.folder_logs_tran_eom
        "--PROCEDURE_NAME"  = "dswtdir2_globe_dbo.sp_mybss_globe_eom_preload_dp3_transform_dummy"
        "--SP_PARAMS"          = "YES"

      }
      )
    },

    {
      name              = "export_2a"
      description       = "Mybss_eom_glob_preload_unbilled_charges_export_prepare-glue : Call DP3 unbilled charges report prepare SP"
      glue_version      = "5.1"
      worker_type       = "G.1X"
      number_of_workers = 10
      connections       = ["postgres"]
      tags              = { PIPELINE = "MyBSS EOM Globe" }

      glue_job_command = [
        {
          name            = "glueetl"
          python_version  = "3"
          script_location = "s3://${local.bucket_name}/${local.aws_product_s3_prefix}/${local.s3_script.GlueDbSpCaller}"
        }
      ]

      execution_property = {
        max_concurrent_runs = 3
      }

      default_arguments = merge(
        var.glue_job_configs.default_arguments,
      {
        "--TempDir"          = "s3://${local.bucket_name}/${local.aws_product_s3_prefix}/tmp/"
        "--CONN_DB_TO"      = "isg-esatp-dv-mybss_gt_eom-glco-postgres"
        "--extra-py-files"  = local.extra_py.dbsp
        "--extra-jars"      = null
        "--FOLDER_LOCATION" = local.folder_logs_exp_eom
        "--PROCEDURE_NAME"  = "dswtdir2_globe_dbo.sp_mybss_globe_eom_preload_dp3_report_prepare_dummy"
      }
      )
    },

    {
      name              = "export_2b"
      description       = "Mybss_eom_glob_preload_unbilled_charges_export-glue : Export DP3 unbilled charges file"
      glue_version      = "5.1"
      worker_type       = "G.1X"
      number_of_workers = 10
      connections       = ["postgres"]
      execution_class   = "STANDARD"
      tags              = { PIPELINE = "MyBSS EOM Globe" }

      glue_job_command = [
        {
          name            = "glueetl"
          python_version  = "3"
          script_location = "s3://${local.bucket_name}/${local.aws_product_s3_prefix}/${local.s3_script.GlueDbSpCaller}"
        }
      ]

      execution_property = {
        max_concurrent_runs = 3
      }

      default_arguments = merge(
        var.glue_job_configs.default_arguments,
      {
        "--TempDir"          = "s3://${local.bucket_name}/${local.aws_product_s3_prefix}/tmp/"
        "--CONN_DB_TO"          = "isg-esatp-dv-mybss_gt_eom-glco-postgres"
        "--extra-py-files"      = local.extra_py.dbsp_export
        "--extra-jars"          = null
        "--FOLDER_LOCATION"     = local.folder_eom
        "--PROCEDURE_NAME"      = "dswtdir2_globe_dbo.sp_mybss_globe_eom_preload_dp3_export_new_dummy"
        "--EXPORT"              = "txGlobe_DP3_Unbilled_Char_ExportSel.txt"
        "--LOAD_TABLE"          = "dswtdir2_globe_dbo.txglobe_dp3_unbilled_char_exportsel_export"
        "--TARGET_FOLDER"       = "outbound/"
      }
      )
    },

    {
      name              = "transform_3"
      description       = "Mybss_eom_glob_preload_unbilled_adjustments_tran-glue : Call DP4 unbilled adjustments transform SP"
      glue_version      = "5.1"
      worker_type       = "G.1X"
      number_of_workers = 10
      connections       = ["postgres"]
      tags              = { PIPELINE = "MyBSS EOM Globe" }

      glue_job_command = [
        {
          name            = "glueetl"
          python_version  = "3"
          script_location = "s3://${local.bucket_name}/${local.aws_product_s3_prefix}/${local.s3_script.GlueDbSpCaller}"
        }
      ]

      execution_property = {
        max_concurrent_runs = 3
      }

      default_arguments = merge(
        var.glue_job_configs.default_arguments,
      {
        "--TempDir"          = "s3://${local.bucket_name}/${local.aws_product_s3_prefix}/tmp/"
        "--CONN_DB_TO"      = "isg-esatp-dv-mybss_gt_eom-glco-postgres"
        "--extra-py-files"  = local.extra_py.dbsp
        "--extra-jars"      = null
        "--FOLDER_LOCATION" = local.folder_logs_tran_eom
        "--PROCEDURE_NAME"  = "dswtdir2_globe_dbo.sp_mybss_globe_eom_preload_dp4_transform_dummy"
        "--SP_PARAMS"          = "YES"

      }
      )
    },

    {
      name              = "export_3a"
      description       = "Mybss_eom_glob_preload_unbilled_adjustments_export_prepare-glue : Call DP4 unbilled adjustments report prepare SP"
      glue_version      = "5.1"
      worker_type       = "G.1X"
      number_of_workers = 10
      connections       = ["postgres"]
      tags              = { PIPELINE = "MyBSS EOM Globe" }

      glue_job_command = [
        {
          name            = "glueetl"
          python_version  = "3"
          script_location = "s3://${local.bucket_name}/${local.aws_product_s3_prefix}/${local.s3_script.GlueDbSpCaller}"
        }
      ]

      execution_property = {
        max_concurrent_runs = 3
      }

      default_arguments = merge(
        var.glue_job_configs.default_arguments,
      {
        "--TempDir"          = "s3://${local.bucket_name}/${local.aws_product_s3_prefix}/tmp/"
        "--CONN_DB_TO"      = "isg-esatp-dv-mybss_gt_eom-glco-postgres"
        "--extra-py-files"  = local.extra_py.dbsp
        "--extra-jars"      = null
        "--FOLDER_LOCATION" = local.folder_logs_exp_eom
        "--PROCEDURE_NAME"  = "dswtdir2_globe_dbo.sp_mybss_globe_eom_preload_dp4_report_prepare_dummy"
      }
      )
    },

    {
      name              = "export_3b"
      description       = "Mybss_eom_glob_preload_unbilled_adjustments_export-glue : Export DP4 unbilled adjustments file"
      glue_version      = "5.1"
      worker_type       = "G.1X"
      number_of_workers = 10
      connections       = ["postgres"]
      execution_class   = "STANDARD"
      tags              = { PIPELINE = "MyBSS EOM Globe" }

      glue_job_command = [
        {
          name            = "glueetl"
          python_version  = "3"
          script_location = "s3://${local.bucket_name}/${local.aws_product_s3_prefix}/${local.s3_script.GlueDbSpCaller}"
        }
      ]

      execution_property = {
        max_concurrent_runs = 3
      }

      default_arguments = merge(
        var.glue_job_configs.default_arguments,
      {
        "--TempDir"          = "s3://${local.bucket_name}/${local.aws_product_s3_prefix}/tmp/"
        "--CONN_DB_TO"          = "isg-esatp-dv-mybss_gt_eom-glco-postgres"
        "--extra-py-files"      = local.extra_py.dbsp_export
        "--extra-jars"          = null
        "--FOLDER_LOCATION"     = local.folder_eom
        "--PROCEDURE_NAME"      = "dswtdir2_globe_dbo.sp_mybss_globe_eom_preload_dp4_export_new_dummy"
        "--EXPORT"              = "txGlobe_DP4_Unbilled_Adj_ExportSel.txt"
        "--LOAD_TABLE"          = "dswtdir2_globe_dbo.txglobe_dp4_unbilled_adj_exportsel_export"
        "--TARGET_FOLDER"       = "outbound/"
      }
      )
    },

    {
      name              = "transform_4"
      description       = "Mybss_eom_glob_preload_unconfirmed_charges_msf_tran-glue : Call DP5 unconfirmed charges MSF transform SP"
      glue_version      = "5.1"
      worker_type       = "G.1X"
      number_of_workers = 10
      connections       = ["postgres"]
      tags              = { PIPELINE = "MyBSS EOM Globe" }

      glue_job_command = [
        {
          name            = "glueetl"
          python_version  = "3"
          script_location = "s3://${local.bucket_name}/${local.aws_product_s3_prefix}/${local.s3_script.GlueDbSpCaller}"
        }
      ]

      execution_property = {
        max_concurrent_runs = 3
      }

      default_arguments = merge(
        var.glue_job_configs.default_arguments,
      {
        "--TempDir"          = "s3://${local.bucket_name}/${local.aws_product_s3_prefix}/tmp/"
        "--CONN_DB_TO"      = "isg-esatp-dv-mybss_gt_eom-glco-postgres"
        "--extra-py-files"  = local.extra_py.dbsp
        "--extra-jars"      = null
        "--FOLDER_LOCATION" = local.folder_logs_tran_eom
        "--PROCEDURE_NAME"  = "dswtdir2_globe_dbo.sp_mybss_globe_eom_preload_dp5_unconfirmed_transform_dummy"
        "--SP_PARAMS"          = "YES"

      }
      )
    },

    {
      name              = "export_4a"
      description       = "Mybss_eom_glob_preload_unconfirmed_charges_msf_export_prepare-glue : Call DP5 unconfirmed charges MSF report prepare SP"
      glue_version      = "5.1"
      worker_type       = "G.1X"
      number_of_workers = 10
      connections       = ["postgres"]
      tags              = { PIPELINE = "MyBSS EOM Globe" }

      glue_job_command = [
        {
          name            = "glueetl"
          python_version  = "3"
          script_location = "s3://${local.bucket_name}/${local.aws_product_s3_prefix}/${local.s3_script.GlueDbSpCaller}"
        }
      ]

      execution_property = {
        max_concurrent_runs = 3
      }

      default_arguments = merge(
        var.glue_job_configs.default_arguments,
      {
        "--TempDir"          = "s3://${local.bucket_name}/${local.aws_product_s3_prefix}/tmp/"
        "--CONN_DB_TO"      = "isg-esatp-dv-mybss_gt_eom-glco-postgres"
        "--extra-py-files"  = local.extra_py.dbsp
        "--extra-jars"      = null
        "--FOLDER_LOCATION" = local.folder_logs_exp_eom
        "--PROCEDURE_NAME"  = "dswtdir2_globe_dbo.sp_mybss_globe_eom_preload_dp5_unconfirmed_report_prepare_dummy"
      }
      )
    },

    {
      name              = "export_4b"
      description       = "Mybss_eom_glob_preload_unconfirmed_charges_msf_export_p1-glue : Export DP5 unconfirmed charges (p1 - CH)"
      glue_version      = "5.1"
      worker_type       = "G.1X"
      number_of_workers = 10
      connections       = ["postgres"]
      execution_class   = "STANDARD"
      tags              = { PIPELINE = "MyBSS EOM Globe" }

      glue_job_command = [
        {
          name            = "glueetl"
          python_version  = "3"
          script_location = "s3://${local.bucket_name}/${local.aws_product_s3_prefix}/${local.s3_script.GlueDbSpCaller}"
        }
      ]

      execution_property = {
        max_concurrent_runs = 3
      }

      default_arguments = merge(
        var.glue_job_configs.default_arguments,
      {
        "--TempDir"          = "s3://${local.bucket_name}/${local.aws_product_s3_prefix}/tmp/"
        "--CONN_DB_TO"          = "isg-esatp-dv-mybss_gt_eom-glco-postgres"
        "--extra-py-files"      = local.extra_py.dbsp_export
        "--extra-jars"          = null
        "--FOLDER_LOCATION"     = local.folder_eom
        "--PROCEDURE_NAME"      = "dswtdir2_globe_dbo.sp_mybss_globe_eom_preload_dp5_unconfirmed_ch_export_new_dummy"
        "--EXPORT"              = "txGlobe_DP5_Unconfirmed_CH_ExporSel.txt"
        "--LOAD_TABLE"          = "dswtdir2_globe_dbo.txglobe_dp5_unconfirmed_ch_exporsel_export"
        "--TARGET_FOLDER"       = "outbound/"
      }
      )
    },

    {
      name              = "export_4c"
      description       = "Mybss_eom_glob_preload_unconfirmed_charges_msf_export_p2-glue : Export DP5 unconfirmed charges (p2 - MSF)"
      glue_version      = "5.1"
      worker_type       = "G.1X"
      number_of_workers = 10
      connections       = ["postgres"]
      execution_class   = "STANDARD"
      tags              = { PIPELINE = "MyBSS EOM Globe" }

      glue_job_command = [
        {
          name            = "glueetl"
          python_version  = "3"
          script_location = "s3://${local.bucket_name}/${local.aws_product_s3_prefix}/${local.s3_script.GlueDbSpCaller}"
        }
      ]

      execution_property = {
        max_concurrent_runs = 3
      }

      default_arguments = merge(
        var.glue_job_configs.default_arguments,
      {
        "--TempDir"          = "s3://${local.bucket_name}/${local.aws_product_s3_prefix}/tmp/"
        "--CONN_DB_TO"          = "isg-esatp-dv-mybss_gt_eom-glco-postgres"
        "--extra-py-files"      = local.extra_py.dbsp_export
        "--extra-jars"          = null
        "--FOLDER_LOCATION"     = local.folder_eom
        "--PROCEDURE_NAME"      = "dswtdir2_globe_dbo.sp_mybss_globe_eom_preload_dp5_unconfirmed_msf_export_new_dummy "
        "--EXPORT"              = "txGlobe_DP5_Unconfirmed_MSF_ExpSel.txt"
        "--LOAD_TABLE"          = "dswtdir2_globe_dbo.txglobe_dp5_unconfirmed_msf_expsel_export"
        "--TARGET_FOLDER"       = "outbound/"
      }
      )
    },

    {
      name              = "transform_5"
      description       = "Mybss_eom_glob_preload_unconfirmed_adjustments_tran-glue : Call DP5 unconfirmed adjustments transform SP"
      glue_version      = "5.1"
      worker_type       = "G.1X"
      number_of_workers = 10
      connections       = ["postgres"]
      tags              = { PIPELINE = "MyBSS EOM Globe" }

      glue_job_command = [
        {
          name            = "glueetl"
          python_version  = "3"
          script_location = "s3://${local.bucket_name}/${local.aws_product_s3_prefix}/${local.s3_script.GlueDbSpCaller}"
        }
      ]

      execution_property = {
        max_concurrent_runs = 3
      }

      default_arguments = merge(
        var.glue_job_configs.default_arguments,
      {
        "--TempDir"          = "s3://${local.bucket_name}/${local.aws_product_s3_prefix}/tmp/"
        "--CONN_DB_TO"      = "isg-esatp-dv-mybss_gt_eom-glco-postgres"
        "--extra-py-files"  = local.extra_py.dbsp
        "--extra-jars"      = null
        "--FOLDER_LOCATION" = local.folder_logs_tran_eom
        "--PROCEDURE_NAME"  = "dswtdir2_globe_dbo.sp_mybss_globe_eom_preload_dp5_unconfirmed_adj_transform_dummy"
        "--SP_PARAMS"          = "YES"

      }
      )
    },

    {
      name              = "export_5a"
      description       = "Mybss_eom_glob_preload_unconfirmed_adjustments_export_prepare-glue : Call DP5 unconfirmed adjustments report prepare SP"
      glue_version      = "5.1"
      worker_type       = "G.1X"
      number_of_workers = 10
      connections       = ["postgres"]
      tags              = { PIPELINE = "MyBSS EOM Globe" }

      glue_job_command = [
        {
          name            = "glueetl"
          python_version  = "3"
          script_location = "s3://${local.bucket_name}/${local.aws_product_s3_prefix}/${local.s3_script.GlueDbSpCaller}"
        }
      ]

      execution_property = {
        max_concurrent_runs = 3
      }

      default_arguments = merge(
        var.glue_job_configs.default_arguments,
      {
        "--TempDir"          = "s3://${local.bucket_name}/${local.aws_product_s3_prefix}/tmp/"
        "--CONN_DB_TO"      = "isg-esatp-dv-mybss_gt_eom-glco-postgres"
        "--extra-py-files"  = local.extra_py.dbsp
        "--extra-jars"      = null
        "--FOLDER_LOCATION" = local.folder_logs_exp_eom
        "--PROCEDURE_NAME"  = "dswtdir2_globe_dbo.sp_mybss_globe_eom_preload_dp5_unconfirmed_adj_report_prepare_d"
      }
      )
    },

    {
      name              = "export_5b"
      description       = "Mybss_eom_glob_preload_unconfirmed_adjustments_export-glue : Export DP5 unconfirmed adjustments aggregated load file"
      glue_version      = "5.1"
      worker_type       = "G.1X"
      number_of_workers = 10
      connections       = ["postgres"]
      execution_class   = "STANDARD"
      tags              = { PIPELINE = "MyBSS EOM Globe" }

      glue_job_command = [
        {
          name            = "glueetl"
          python_version  = "3"
          script_location = "s3://${local.bucket_name}/${local.aws_product_s3_prefix}/${local.s3_script.GlueDbSpCaller}"
        }
      ]

      execution_property = {
        max_concurrent_runs = 3
      }

      default_arguments = merge(
        var.glue_job_configs.default_arguments,
      {
        "--TempDir"          = "s3://${local.bucket_name}/${local.aws_product_s3_prefix}/tmp/"
        "--CONN_DB_TO"          = "isg-esatp-dv-mybss_gt_eom-glco-postgres"
        "--extra-py-files"      = local.extra_py.dbsp_export
        "--extra-jars"          = null
        "--FOLDER_LOCATION"     = local.folder_eom
        "--PROCEDURE_NAME"      = "dswtdir2_globe_dbo.sp_mybss_globe_eom_preload_dp5_export_unconfirmed_adj_new_dummy"
        "--EXPORT"              = "txGlobe_DP5_Unconfirmed_Adj_LoadFile.txt"
        "--LOAD_TABLE"          = "dswtdir2_globe_dbo.txglobe_dp5_unconfirmed_adj_agg_exportsel_export"
        "--TARGET_FOLDER"       = "outbound/"
      }
      )
    }
  ]

}
