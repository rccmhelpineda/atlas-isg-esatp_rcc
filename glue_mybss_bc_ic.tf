locals {
  pipeline_s3_root_inov = "bss_billcycle_inov"
  folder_inov           = "${local.bucket_name_storage}/${local.pipeline_s3_root_inov}/"
  folder_logs_tran_inov = "${local.bucket_name_storage}/${local.pipeline_s3_root_inov}/_logs-transform"
  folder_logs_exp_inov  = "${local.bucket_name_storage}/${local.pipeline_s3_root_inov}/_logs-export_prepare"
}

module "glue_extract_ic" {
  source = "./modules/aws-glue"

  providers = {
    aws.environment = aws.environment,
    aws.security    = aws.security,
    aws.dr          = aws.dr,  
    aws.security_dr = aws.security_dr
  }

  #depends_on = [ module.s3_module,module.s3_module_2 ]

  s3_bucket_name     = ["storage","scripts"]

  name = "mybss_ic"

  sns_topic_name = null

  glue_database  = []
  
  source_secrets_manager_arn          = var.dbSecret
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
            security_group_id_list = [var.glueConnectionSG_NW1[5]]
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
    { # 
      name              = "extract_mgr" 
      description       = "Mybss_billcycle_inov_preload_extract-glue : Orchestrator: start extract child jobs (308, 318, 411 PHP/USD, SAP glbilled)"
      glue_version      = "5.1"
      worker_type       = var.glue_job_configs.worker_type_High
      number_of_workers = var.glue_job_configs.number_of_workers
      tags              = { PIPELINE = "MyBSS BC Innove" }

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
        "--TempDir"          = "s3://${local.bucket_name}/${local.aws_product_s3_prefix}/tmp/"
        "--extra-py-files"   = local.extra_py.orchestrator
        "--job_list"         = "${var.env_prefix}-mybss_ic-gljo-extract_1,${var.env_prefix}-mybss_ic-gljo-extract_2,${var.env_prefix}-mybss_ic-gljo-extract_3,${var.env_prefix}-mybss_ic-gljo-extract_4,${var.env_prefix}-mybss_ic-gljo-extract_5"
        "--passed_parameter" = var.default_passed_parameter   
        }             
      )
    },

    { # 
      name              = "extract_1"
      description       = "Mybss_billcycle_inov_preload_extract-glue_308 : Extract 308 billed adjustments Excel → Aurora"
      glue_version       = "4.0"
      worker_type       = var.glue_job_configs.worker_type
      number_of_workers = var.glue_job_configs.number_of_workers
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
        max_concurrent_runs = 12
      }

      default_arguments = merge(
        var.glue_job_configs.default_arguments,
      {
        "--TempDir"          = "s3://${local.bucket_name}/${local.aws_product_s3_prefix}/tmp/"
        "--user-jars-first"  = "true"
        "--extra-py-files"   = local.extra_py.spreadsheet
        "--extra-jars"       = local.extra_jars
        "--connection_name"  = "${var.env_prefix}-mybss_ic-glco-postgres"
        "--audit_table"      = "sdbtdir2_innove_dbo.308_Billed_Adjustments_ssis"
        "--folder_location"  = local.folder_inov
        "--input_file_name"  = "308. Billed Adjustments Monthly Summary Report_I_{BCNUM}.xlsx"
        "--target_table"     = "sdbtdir2_innove_dbo.308_Billed_Adjustments_{BCNUM}"
        "--passed_parameter" = var.default_passed_parameter
      }
      )
    },

    { #
      name              = "extract_2"
      description       = "Mybss_billcycle_inov_preload_extract-glue_318 : Extract 318 billed charges Excel → Aurora"
      glue_version      = "4.0"
      worker_type       = var.glue_job_configs.worker_type
      number_of_workers = var.glue_job_configs.number_of_workers
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
        max_concurrent_runs = 12
      }

      default_arguments = merge(
        var.glue_job_configs.default_arguments,
      {
        "--TempDir"          = "s3://${local.bucket_name}/${local.aws_product_s3_prefix}/tmp/"
        "--user-jars-first"  = "true"
        "--extra-py-files"   = local.extra_py.spreadsheet
        "--extra-jars"       = local.extra_jars
        "--connection_name"  = "${var.env_prefix}-mybss_ic-glco-postgres"
        "--audit_table"      = "sdbtdir2_innove_dbo.318_Billed_Charges_ssis"
        "--folder_location"  = local.folder_inov
        "--input_file_name"  = "318. Billed Charges Summary Report_I_{BCNUM}.XLSX"
        "--target_table"     = "sdbtdir2_innove_dbo.318_Billed_Charges_{BCNUM}"
        "--passed_parameter" = var.default_passed_parameter
      }
      )
    },

    { # 
      name              = "extract_3"
      description       = "Mybss_billcycle_inov_preload_extract-glue_411PHP : Extract 411 bill control PHP Excel → Aurora"
      glue_version      = "4.0"
      worker_type       = var.glue_job_configs.worker_type
      number_of_workers = var.glue_job_configs.number_of_workers
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
        max_concurrent_runs = 12
      }

      default_arguments = merge(
        var.glue_job_configs.default_arguments,
      {
        "--TempDir"          = "s3://${local.bucket_name}/${local.aws_product_s3_prefix}/tmp/"
        "--user-jars-first"  = "true"
        "--connection_name"  = "${var.env_prefix}-mybss_ic-glco-postgres"
        "--extra-py-files"   = local.extra_py.spreadsheet
        "--extra-jars"       = local.extra_jars        
        "--audit_table"      = "sdbtdir2_innove_dbo.411_Bill_Control_PHP_ssis"
        "--folder_location"  = local.folder_inov
        "--input_file_name"  = "411. Bill Control_PHP_I_{BCNUM}.XLSX"
        "--target_table"     = "sdbtdir2_innove_dbo.411_Bill_Control_PHP_{BCNUM}"
        "--passed_parameter" = var.default_passed_parameter
      }
      )
    },

    { # 
      name              = "extract_4"
      description       = "Mybss_billcycle_inov_preload_extract-glue_411USD : Extract 411 bill control USD Excel → Aurora"
      glue_version      = "4.0"
      worker_type       = var.glue_job_configs.worker_type
      number_of_workers = var.glue_job_configs.number_of_workers
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
        max_concurrent_runs = 12
      }

      default_arguments = merge(
        var.glue_job_configs.default_arguments,
      {
        "--TempDir"          = "s3://${local.bucket_name}/${local.aws_product_s3_prefix}/tmp/"
        "--user-jars-first"  = "true"
        "--connection_name"  = "${var.env_prefix}-mybss_ic-glco-postgres"
        "--extra-py-files"   = local.extra_py.spreadsheet
        "--extra-jars"       = local.extra_jars
        "--target_table"     = "sdbtdir2_innove_dbo.411_Bill_Control_USD_{BCNUM}"
        "--input_file_name"  = "411. Bill Control_USD_I_{BCNUM}.XLSX"
        "--audit_table"      = "sdbtdir2_innove_dbo.411_Bill_Control_USD_ssis"
        "--folder_location"  = local.folder_inov
        "--passed_parameter" = var.default_passed_parameter
      }
      )
    },

    { # 
      name              = "extract_5"
      description       = "Mybss_billcycle_inov_preload_extract-glue_SAP_glbilled : Extract SAP glbilled text → Aurora"
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
        max_concurrent_runs = 12
      }

      default_arguments = merge(
        var.glue_job_configs.default_arguments,
      {
        "--TempDir"          = "s3://${local.bucket_name}/${local.aws_product_s3_prefix}/tmp/"
        "--user-jars-first"    = "true"
        "--connection_name"    = "${var.env_prefix}-mybss_ic-glco-postgres"
        "--extra-py-files"     = local.extra_py.text
        "--target_table"       = "sdbtdir2_innove_dbo.sap_glbilled_{BCNUM}"
        "--input_file_name"    = "sap_glbilled_I_{BCNUM}.txt"
        "--audit_table"        = "sdbtdir2_innove_dbo.sap_glbilled_ssis"
        "--folder_location"    = local.folder_inov
        "--passed_parameter"   = var.default_passed_parameter
        "--delimiter_regex"    = "\\t"
        "--filter_record_type" = "ALL"
        "--expected_columns"   = "30"
        "--col_label"          = "column"
        "--row_number_label"   = "zrownumber"
      }
      )
    },

    { # 
      name              = "sap_preload"
      description       = "Mybss_billcycle_inov_preload_sap-glue : Call Aurora SP sp_mybss_innove_eoc_preload_loadsaptables"
      glue_version      = "5.1"
      worker_type       = var.glue_job_configs.worker_type
      number_of_workers = var.glue_job_configs.number_of_workers
      connections       = ["postgres"]
      tags              = { PIPELINE = "MyBSS BC innove" }

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
        "--CONN_DB_TO"      = "${var.env_prefix}-mybss_ic-glco-postgres"
        "--extra-py-files"  = local.extra_py.dbsp
        "--FOLDER_LOCATION" = local.folder_logs_tran
        "--PROCEDURE_NAME"  = "dswtdir2_innove_dbo.sp_mybss_innove_eoc_preload_loadsaptables"
      }
      )
    },

    { # 
      name              = "transform"
      description       = "Mybss_billcycle_inov_preload_tran-glue : Call Aurora SP sp_mybss_innove_eoc_preload_transform_dummy"
      glue_version       = "5.1"
      worker_type       = var.glue_job_configs.worker_type
      number_of_workers = var.glue_job_configs.number_of_workers
      connections       = ["postgres"]
      tags              = { PIPELINE = "MyBSS BC innove" }
      
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
        "--CONN_DB_TO"      = "${var.env_prefix}-mybss_ic-glco-postgres"
        "--extra-py-files"  = local.extra_py.dbsp
        "--FOLDER_LOCATION" = local.folder_logs_tran
        "--PROCEDURE_NAME"  = "dswtdir2_innove_dbo.sp_mybss_innove_eoc_preload_transform_dummy"
        "--CODE"            = "BC27"
        "--BYPASS"          = "True"
        "--SP_PARAMS"       = "YES"
      }
      )
    },

    { # 
      name              = "export_prep"
      description       = "Mybss_billcycle_inov_preload_export_prepare-glue : Call Aurora SP sp_mybss_innove_eoc_preload_report_prepare_dummy"
      glue_version       = "5.1"
      worker_type       = var.glue_job_configs.worker_type
      number_of_workers = var.glue_job_configs.number_of_workers
      connections       = ["postgres"]
      tags              = { PIPELINE = "MyBSS BC innove" }
      
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
        "--CONN_DB_TO"      = "${var.env_prefix}-mybss_ic-glco-postgres"
        "--extra-py-files"  = local.extra_py.dbsp
        "--FOLDER_LOCATION" = local.folder_logs_exp
        "--PROCEDURE_NAME"  = "dswtdir2_innove_dbo.sp_mybss_innove_eoc_preload_report_prepare_dummy"
        "--CODE"            = "BC01"
        "--BYPASS"          = "True"
      }
      )
    },

    { # 
      name              = "export"
      description       = "Mybss_billcycle_inov_preload_export-glue : Call transform SP then export billed load file to outbound/"
      glue_version       = "5.1"
      worker_type       = var.glue_job_configs.worker_type
      number_of_workers = var.glue_job_configs.number_of_workers
      connections       = ["postgres"]
      execution_class   = "STANDARD"
      tags              = { PIPELINE = "MyBSS BC innove" }

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
        "--CONN_DB_TO"          = "${var.env_prefix}-mybss_ic-glco-postgres"
        "--extra-py-files"      = local.extra_py.dbsp_export
        "--FOLDER_LOCATION"  = local.folder_inov
        "--PROCEDURE_NAME"   = "dswtdir2_innove_dbo.sp_mybss_innove_eoc_preload_transform_dummy"
        "--CODE"             = "BC27"
        "--EXPORT"           = "txinnove_Billed_{CODE}_LoadFileSel.txt"
        "--LOAD_TABLE"       = "dswtdir2_innove_dbo.tvinnove_billed_preload_cyclexrptsel_export"
        "--TARGET_FOLDER"    = "outbound/"
        "--FILTER_DROP_COL"  = "zlegacycycle_code"
      }
      )
    }
  ]

}
