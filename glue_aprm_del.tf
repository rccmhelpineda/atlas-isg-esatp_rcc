locals {
  folder_aprm_del = "${local.bucket_name_storage}/aprm_voice_delta/"
  aprm_del_csv_target_headers = join(",", [
    "INTERCONNECT PARTNER NAME",
    "INTERCONNECT PARTNER CODE",
    "SAP VENDOR CODE",
    "ORIG BP DATE",
    "BP END DATE",
    "BRAND",
    "CUSTOMER TYPE",
    "SUB SERVICE TYPE",
    "CUSTOMER SUBTYPE",
    "SERVICE DIRECTION",
    "TRAFFIC STREAM",
    "RATING TYPE",
    "NO OF CALLS",
    "NO OF SUBSCRIPTIONS",
    "ACTUAL DURATION",
    "SETTABLE DURATION",
    "NET SETTABLE AMT",
    "TAX AMOUNT",
    "CURRENCY",
    "INBOUND ROAMER INDICATOR",
    "CHARGE DIRECTION",
  ])
}

module "glue_aprm_del_bt" {
  source = "./modules/aws-glue"

  providers = {
    aws.environment = aws.environment,
    aws.security    = aws.security,
    aws.dr          = aws.dr,
    aws.security_dr = aws.security_dr
  }

  s3_bucket_name = ["storage", "scripts"]
  name           = "aprm_del_bt"
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
      description       = "APRM DELTA : ICEXT_BYN_I_VOICE.txt → sdbtdir3_aprm_dbo.sap_byn_delta_voice"
      glue_version      = "5.1"
      worker_type       = var.glue_job_configs.worker_type
      number_of_workers = var.glue_job_configs.number_of_workers
      connections       = ["postgres"]
      tags              = { INGESTION_TYPE = "TXT_NUMBERED", PIPELINE = "APRM DELTA" }

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
          "--connection_name"    = "${var.env_prefix}-aprm_del_bt-glco-postgres"
          "--extra-py-files"     = local.extra_py.text
          "--target_table"       = "sdbtdir3_aprm_dbo.sap_byn_delta_voice"
          "--folder_location"    = local.folder_aprm_del
          "--input_file_name"    = "ICEXT_BYN_I_VOICE.txt"
          "--delimiter_regex"    = "\\t"
          "--filter_record_type" = "ALL"
          "--expected_columns"   = "30"
          "--col_label"          = "column"
          "--row_number_label"   = "rownumber"
          "--include_date"       = "dateread"
          "--include_filename"   = "filename"
        }
      )
    },
    {
      name              = "extract_2"
      description       = "APRM DELTA : SAP_REPORT_BYN_DELTA.CSV → sdbtdir3_aprm_dbo.sap_report_byn_delta_voice"
      glue_version      = "5.1"
      worker_type       = var.glue_job_configs.worker_type
      number_of_workers = var.glue_job_configs.number_of_workers
      connections       = ["postgres"]
      tags              = { INGESTION_TYPE = "CSV_NUMBERED", PIPELINE = "APRM DELTA" }

      glue_job_command = [
        {
          name            = "glueetl"
          python_version  = "3"
          script_location = "s3://${local.bucket_name}/${local.aws_product_s3_prefix}/${local.commons_s3_prefix}/scripts/GlueCsv.py"
        }
      ]

      execution_property = {
        max_concurrent_runs = 2
      }

      default_arguments = merge(
        var.glue_job_configs.default_arguments,
        {
          "--TempDir"            = "s3://${local.bucket_name_storage}/${local.aws_product_s3_prefix}/tmp/"
          "--connection_name"    = "${var.env_prefix}-aprm_del_bt-glco-postgres"
          "--extra-py-files"     = local.extra_py_csv
          "--target_table"       = "sdbtdir3_aprm_dbo.sap_report_byn_delta_voice"
          "--folder_location"    = local.folder_aprm_del
          "--input_file_name"    = "SAP_REPORT_BYN_DELTA.CSV"
          "--delimiter_regex"    = ","
          "--row_number_label"   = "zrownumber"
          "--include_date"       = "dateread"
          "--include_filename"   = "filename"
          "--target_headers"     = local.aprm_del_csv_target_headers
        }
      )
    },
    {
      name              = "extract_3"
      description       = "APRM DELTA : SAP_REPORT_BYN_FINAL.CSV → sdbtdir3_aprm_dbo.sap_report_byn_final_voice"
      glue_version      = "5.1"
      worker_type       = var.glue_job_configs.worker_type
      number_of_workers = var.glue_job_configs.number_of_workers
      connections       = ["postgres"]
      tags              = { INGESTION_TYPE = "CSV_NUMBERED", PIPELINE = "APRM DELTA" }

      glue_job_command = [
        {
          name            = "glueetl"
          python_version  = "3"
          script_location = "s3://${local.bucket_name}/${local.aws_product_s3_prefix}/${local.commons_s3_prefix}/scripts/GlueCsv.py"
        }
      ]

      execution_property = {
        max_concurrent_runs = 2
      }

      default_arguments = merge(
        var.glue_job_configs.default_arguments,
        {
          "--TempDir"            = "s3://${local.bucket_name_storage}/${local.aws_product_s3_prefix}/tmp/"
          "--connection_name"    = "${var.env_prefix}-aprm_del_bt-glco-postgres"
          "--extra-py-files"     = local.extra_py_csv
          "--target_table"       = "sdbtdir3_aprm_dbo.sap_report_byn_final_voice"
          "--folder_location"    = local.folder_aprm_del
          "--input_file_name"    = "SAP_REPORT_BYN_FINAL.CSV"
          "--delimiter_regex"    = ","
          "--row_number_label"   = "zrownumber"
          "--include_date"       = "dateread"
          "--include_filename"   = "filename"
          "--target_headers"     = local.aprm_del_csv_target_headers
        }
      )
    }
  ]
}

module "glue_aprm_del_gt" {
  source = "./modules/aws-glue"

  providers = {
    aws.environment = aws.environment,
    aws.security    = aws.security,
    aws.dr          = aws.dr,
    aws.security_dr = aws.security_dr
  }

  s3_bucket_name = ["storage", "scripts"]
  name           = "aprm_del_gt"
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
      description       = "APRM DELTA : ICEXT_GLB_I_VOICE.txt → sdbtdir3_aprm_dbo.sap_glb_delta_voice"
      glue_version      = "5.1"
      worker_type       = var.glue_job_configs.worker_type
      number_of_workers = var.glue_job_configs.number_of_workers
      connections       = ["postgres"]
      tags              = { INGESTION_TYPE = "TXT_NUMBERED", PIPELINE = "APRM DELTA" }

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
          "--connection_name"    = "${var.env_prefix}-aprm_del_gt-glco-postgres"
          "--extra-py-files"     = local.extra_py.text
          "--target_table"       = "sdbtdir3_aprm_dbo.sap_glb_delta_voice"
          "--folder_location"    = local.folder_aprm_del
          "--input_file_name"    = "ICEXT_GLB_I_VOICE.txt"
          "--delimiter_regex"    = "\\t"
          "--filter_record_type" = "ALL"
          "--expected_columns"   = "30"
          "--col_label"          = "column"
          "--row_number_label"   = "rownumber"
          "--include_date"       = "dateread"
          "--include_filename"   = "filename"
        }
      )
    },
    {
      name              = "extract_2"
      description       = "APRM DELTA : SAP_REPORT_GLB_DELTA.CSV → sdbtdir3_aprm_dbo.sap_report_glb_delta_voice"
      glue_version      = "5.1"
      worker_type       = var.glue_job_configs.worker_type
      number_of_workers = var.glue_job_configs.number_of_workers
      connections       = ["postgres"]
      tags              = { INGESTION_TYPE = "CSV_NUMBERED", PIPELINE = "APRM DELTA" }

      glue_job_command = [
        {
          name            = "glueetl"
          python_version  = "3"
          script_location = "s3://${local.bucket_name}/${local.aws_product_s3_prefix}/${local.commons_s3_prefix}/scripts/GlueCsv.py"
        }
      ]

      execution_property = {
        max_concurrent_runs = 2
      }

      default_arguments = merge(
        var.glue_job_configs.default_arguments,
        {
          "--TempDir"            = "s3://${local.bucket_name_storage}/${local.aws_product_s3_prefix}/tmp/"
          "--connection_name"    = "${var.env_prefix}-aprm_del_gt-glco-postgres"
          "--extra-py-files"     = local.extra_py_csv
          "--target_table"       = "sdbtdir3_aprm_dbo.sap_report_glb_delta_voice"
          "--folder_location"    = local.folder_aprm_del
          "--input_file_name"    = "SAP_REPORT_GLB_DELTA.CSV"
          "--delimiter_regex"    = ","
          "--row_number_label"   = "zrownumber"
          "--include_date"       = "dateread"
          "--include_filename"   = "filename"
          "--target_headers"     = local.aprm_del_csv_target_headers
        }
      )
    },
    {
      name              = "extract_3"
      description       = "APRM DELTA : SAP_REPORT_GLB_FINAL.CSV → sdbtdir3_aprm_dbo.sap_report_glb_final_voice"
      glue_version      = "5.1"
      worker_type       = var.glue_job_configs.worker_type
      number_of_workers = var.glue_job_configs.number_of_workers
      connections       = ["postgres"]
      tags              = { INGESTION_TYPE = "CSV_NUMBERED", PIPELINE = "APRM DELTA" }

      glue_job_command = [
        {
          name            = "glueetl"
          python_version  = "3"
          script_location = "s3://${local.bucket_name}/${local.aws_product_s3_prefix}/${local.commons_s3_prefix}/scripts/GlueCsv.py"
        }
      ]

      execution_property = {
        max_concurrent_runs = 2
      }

      default_arguments = merge(
        var.glue_job_configs.default_arguments,
        {
          "--TempDir"            = "s3://${local.bucket_name_storage}/${local.aws_product_s3_prefix}/tmp/"
          "--connection_name"    = "${var.env_prefix}-aprm_del_gt-glco-postgres"
          "--extra-py-files"     = local.extra_py_csv
          "--target_table"       = "sdbtdir3_aprm_dbo.sap_report_glb_final_voice"
          "--folder_location"    = local.folder_aprm_del
          "--input_file_name"    = "SAP_REPORT_GLB_FINAL.CSV"
          "--delimiter_regex"    = ","
          "--row_number_label"   = "zrownumber"
          "--include_date"       = "dateread"
          "--include_filename"   = "filename"
          "--target_headers"     = local.aprm_del_csv_target_headers
        }
      )
    }
  ]
}

module "glue_aprm_del_ic" {
  source = "./modules/aws-glue"

  providers = {
    aws.environment = aws.environment,
    aws.security    = aws.security,
    aws.dr          = aws.dr,
    aws.security_dr = aws.security_dr
  }

  s3_bucket_name = ["storage", "scripts"]
  name           = "aprm_del_ic"
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
      description       = "APRM DELTA : ICEXT_INV_I_VOICE.txt → sdbtdir3_aprm_dbo.sap_inv_delta_voice"
      glue_version      = "5.1"
      worker_type       = var.glue_job_configs.worker_type
      number_of_workers = var.glue_job_configs.number_of_workers
      connections       = ["postgres"]
      tags              = { INGESTION_TYPE = "TXT_NUMBERED", PIPELINE = "APRM DELTA" }

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
          "--connection_name"    = "${var.env_prefix}-aprm_del_ic-glco-postgres"
          "--extra-py-files"     = local.extra_py.text
          "--target_table"       = "sdbtdir3_aprm_dbo.sap_inv_delta_voice"
          "--folder_location"    = local.folder_aprm_del
          "--input_file_name"    = "ICEXT_INV_I_VOICE.txt"
          "--delimiter_regex"    = "\\t"
          "--filter_record_type" = "ALL"
          "--expected_columns"   = "30"
          "--col_label"          = "column"
          "--row_number_label"   = "rownumber"
          "--include_date"       = "dateread"
          "--include_filename"   = "filename"
        }
      )
    },
    {
      name              = "extract_2"
      description       = "APRM DELTA : SAP_REPORT_INV_DELTA.CSV → sdbtdir3_aprm_dbo.sap_report_inv_delta_voice"
      glue_version      = "5.1"
      worker_type       = var.glue_job_configs.worker_type
      number_of_workers = var.glue_job_configs.number_of_workers
      connections       = ["postgres"]
      tags              = { INGESTION_TYPE = "CSV_NUMBERED", PIPELINE = "APRM DELTA" }

      glue_job_command = [
        {
          name            = "glueetl"
          python_version  = "3"
          script_location = "s3://${local.bucket_name}/${local.aws_product_s3_prefix}/${local.commons_s3_prefix}/scripts/GlueCsv.py"
        }
      ]

      execution_property = {
        max_concurrent_runs = 2
      }

      default_arguments = merge(
        var.glue_job_configs.default_arguments,
        {
          "--TempDir"            = "s3://${local.bucket_name_storage}/${local.aws_product_s3_prefix}/tmp/"
          "--connection_name"    = "${var.env_prefix}-aprm_del_ic-glco-postgres"
          "--extra-py-files"     = local.extra_py_csv
          "--target_table"       = "sdbtdir3_aprm_dbo.sap_report_inv_delta_voice"
          "--folder_location"    = local.folder_aprm_del
          "--input_file_name"    = "SAP_REPORT_INV_DELTA.CSV"
          "--delimiter_regex"    = ","
          "--row_number_label"   = "zrownumber"
          "--include_date"       = "dateread"
          "--include_filename"   = "filename"
          "--target_headers"     = local.aprm_del_csv_target_headers
        }
      )
    },
    {
      name              = "extract_3"
      description       = "APRM DELTA : SAP_REPORT_INV_FINAL.CSV → sdbtdir3_aprm_dbo.sap_report_inv_final_voice"
      glue_version      = "5.1"
      worker_type       = var.glue_job_configs.worker_type
      number_of_workers = var.glue_job_configs.number_of_workers
      connections       = ["postgres"]
      tags              = { INGESTION_TYPE = "CSV_NUMBERED", PIPELINE = "APRM DELTA" }

      glue_job_command = [
        {
          name            = "glueetl"
          python_version  = "3"
          script_location = "s3://${local.bucket_name}/${local.aws_product_s3_prefix}/${local.commons_s3_prefix}/scripts/GlueCsv.py"
        }
      ]

      execution_property = {
        max_concurrent_runs = 2
      }

      default_arguments = merge(
        var.glue_job_configs.default_arguments,
        {
          "--TempDir"            = "s3://${local.bucket_name_storage}/${local.aws_product_s3_prefix}/tmp/"
          "--connection_name"    = "${var.env_prefix}-aprm_del_ic-glco-postgres"
          "--extra-py-files"     = local.extra_py_csv
          "--target_table"       = "sdbtdir3_aprm_dbo.sap_report_inv_final_voice"
          "--folder_location"    = local.folder_aprm_del
          "--input_file_name"    = "SAP_REPORT_INV_FINAL.CSV"
          "--delimiter_regex"    = ","
          "--row_number_label"   = "zrownumber"
          "--include_date"       = "dateread"
          "--include_filename"   = "filename"
          "--target_headers"     = local.aprm_del_csv_target_headers
        }
      )
    }
  ]
}