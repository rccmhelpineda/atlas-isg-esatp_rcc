locals {
  folder_aprm = "${local.bucket_name_storage}/aprm_voice_accrual/"
  aprm_acc_output_valid_columns = join(",", [
    "Company Code",
    "Document Number",
    "Interconnect Partner name",
    "Interconnect Partner code",
    "SAP vendor Code",
    "Original Billing Period Date",
    "Billing Period End Date",
    "Brand",
    "Sub Product A",
    "Revenue Type",
    "MVNO Partner",
    "Quantity (Settable duration)",
    "Amount in Document Currency",
    "Amount in PHP",
    "Amount in USD",
    "Tax amount",
    "Direction",
  ])
  aprm_acc_csv_target_headers = join(",", [
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
  extra_py_csv = join(",", [
    "s3://${local.bucket_name}/${local.aws_product_s3_prefix}/${local.commons_s3_prefix}/imports/CsvIngester.py",
    "s3://${local.bucket_name}/${local.aws_product_s3_prefix}/${local.py.Utils}",
    "s3://${local.bucket_name}/${local.aws_product_s3_prefix}/${local.py.UtilsAWS}",
    "s3://${local.bucket_name}/${local.aws_product_s3_prefix}/${local.py.CustomDbConnLibs}",
    "s3://${local.bucket_name}/${local.aws_product_s3_prefix}/${local.py.CustomErrorLibs}",
  ])
  aprm_acc_prime_target_headers = join(",", [
    "Partner Code",
    "Partner Name",
    "EVENT_DATE",
    "BP_START_DATE",
    "Product Name",
    "Event Name",
    "Rate Plan",
    "Unit of Measurement",
    "Tax Set",
    "Rates Currency",
    "ORIG_BILLING Period Time",
    "Period Description",
    "OFFNET ONNET Ind Description",
    "Hour Ind Description",
    "Number Zone Description",
    "Customer Type",
    "Sub Service Type",
    "Customer Sub Type",
    "Home Partner",
    "Destination Name",
    "Third Party Service",
    "Inbound Roaming Ind",
    "Brand Type",
    "Rating Type",
    "Call Type",
    "Call Type Description",
    "Call Category",
    "Call Category Description",
    "Misrouted Calls Ind",
    "Misrouted Calls Ind Description",
    "Traffic Type Desc",
    "Rate Per Unit",
    "Event Direction",
    "Jurisdiction",
    "Charge Direction",
    "Total Net One Time Charge",
    "Total Net Access Charge",
    "Total Net Recurring Charge",
    "Total Orig Duration",
    "Total Duration",
    "Total Net Usage Charge",
    "Total Net Charge",
    "Number of Events",
  ])
}

module "glue_aprm_acc_bt" {
  source = "./modules/aws-glue"

  providers = {
    aws.environment = aws.environment,
    aws.security    = aws.security,
    aws.dr          = aws.dr,
    aws.security_dr = aws.security_dr
  }

  s3_bucket_name = ["storage", "scripts"]
  name           = "aprm_acc_bt"
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
      description       = "APRM ACCRUAL Bayan : ICEXT_BYN_A_VOICE.txt → sdbtdir3_aprm_dbo.icext_byn_a_voice"
      glue_version      = "5.1"
      worker_type       = var.glue_job_configs.worker_type
      number_of_workers = var.glue_job_configs.number_of_workers
      connections       = ["postgres"]
      tags              = { INGESTION_TYPE = "TXT", PIPELINE = "APRM ACCRUAL Bayan" }

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
          "--TempDir"            = "s3://${local.bucket_name}/${local.aws_product_s3_prefix}/tmp/"
          "--connection_name"    = "${var.env_prefix}-aprm_acc_bt-glco-postgres"
          "--extra-py-files"     = local.extra_py.text
          "--target_table"       = "sdbtdir3_aprm_dbo.icext_byn_a_voice"
          "--folder_location"    = local.folder_aprm
          "--input_file_name"    = "ICEXT_BYN_A_VOICE.txt"
          "--delimiter_regex"    = "\\t"
          "--filter_record_type" = "ALL"
          "--expected_columns"   = "30"
          "--col_label"          = "column"
        }
      )
    },
    {
      name              = "extract_2"
      description       = "APRM ACCRUAL Bayan : ICEXT_BYN_A_VOICE_OUTPUT.TXT → sdbtdir3_aprm_dbo.icext_byn_a_voice_output"
      glue_version      = "5.1"
      worker_type       = var.glue_job_configs.worker_type
      number_of_workers = var.glue_job_configs.number_of_workers
      connections       = ["postgres"]
      tags              = { INGESTION_TYPE = "TXT_COLUMNED", PIPELINE = "APRM ACCRUAL Bayan" }

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
          "--TempDir"            = "s3://${local.bucket_name}/${local.aws_product_s3_prefix}/tmp/"
          "--connection_name"    = "${var.env_prefix}-aprm_acc_bt-glco-postgres"
          "--extra-py-files"     = local.extra_py.text
          "--target_table"       = "sdbtdir3_aprm_dbo.icext_byn_a_voice_output"
          "--folder_location"    = local.folder_aprm
          "--input_file_name"    = "ICEXT_BYN_A_VOICE_OUTPUT.TXT"
          "--delimiter_regex"    = "\\t"
          "--filter_record_type" = "ALL"
          "--valid_columns"      = local.aprm_acc_output_valid_columns
          "--skip_header_lines"  = "2"
        }
      )
    },
    {
      name              = "extract_3"
      description       = "APRM ACCRUAL Bayan : SAP_REPORT_BYN_ACCRUAL.CSV → sdbtdir3_aprm_dbo.sap_report_byn_accrual"
      glue_version      = "5.1"
      worker_type       = var.glue_job_configs.worker_type
      number_of_workers = var.glue_job_configs.number_of_workers
      connections       = ["postgres"]
      tags              = { INGESTION_TYPE = "CSV", PIPELINE = "APRM ACCRUAL Bayan" }

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
          "--TempDir"          = "s3://${local.bucket_name}/${local.aws_product_s3_prefix}/tmp/"
          "--connection_name"  = "${var.env_prefix}-aprm_acc_bt-glco-postgres"
          "--extra-py-files"   = local.extra_py_csv
          "--target_table"     = "sdbtdir3_aprm_dbo.sap_report_byn_accrual"
          "--folder_location"  = local.folder_aprm
          "--input_file_name"  = "SAP_REPORT_BYN_ACCRUAL.CSV"
          "--delimiter_regex"  = ","
          "--target_headers"   = local.aprm_acc_csv_target_headers
        }
      )
    }
  ]
}

module "glue_aprm_acc_gt" {
  source = "./modules/aws-glue"

  providers = {
    aws.environment = aws.environment,
    aws.security    = aws.security,
    aws.dr          = aws.dr,
    aws.security_dr = aws.security_dr
  }

  s3_bucket_name = ["storage", "scripts"]
  name           = "aprm_acc_gt"
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
          security_group_id_list = [var.glueConnectionSG_NW1[1]]
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
      description       = "APRM ACCRUAL Globe : ICEXT_GLB_A_VOICE.txt → sdbtdir3_aprm_dbo.icext_glb_a_voice"
      glue_version      = "5.1"
      worker_type       = var.glue_job_configs.worker_type
      number_of_workers = var.glue_job_configs.number_of_workers
      connections       = ["postgres"]
      tags              = { INGESTION_TYPE = "TXT", PIPELINE = "APRM ACCRUAL Globe" }

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
          "--TempDir"            = "s3://${local.bucket_name}/${local.aws_product_s3_prefix}/tmp/"
          "--connection_name"    = "${var.env_prefix}-aprm_acc_gt-glco-postgres"
          "--extra-py-files"     = local.extra_py.text
          "--target_table"       = "sdbtdir3_aprm_dbo.icext_glb_a_voice"
          "--folder_location"    = local.folder_aprm
          "--input_file_name"    = "ICEXT_GLB_A_VOICE.txt"
          "--delimiter_regex"    = "\\t"
          "--filter_record_type" = "ALL"
          "--expected_columns"   = "30"
          "--col_label"          = "column"
        }
      )
    },
    {
      name              = "extract_2"
      description       = "APRM ACCRUAL Globe : ICEXT_GLB_A_VOICE_OUTPUT.TXT → sdbtdir3_aprm_dbo.icext_glb_a_voice_output"
      glue_version      = "5.1"
      worker_type       = var.glue_job_configs.worker_type
      number_of_workers = var.glue_job_configs.number_of_workers
      connections       = ["postgres"]
      tags              = { INGESTION_TYPE = "TXT_COLUMNED", PIPELINE = "APRM ACCRUAL Globe" }

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
          "--TempDir"            = "s3://${local.bucket_name}/${local.aws_product_s3_prefix}/tmp/"
          "--connection_name"    = "${var.env_prefix}-aprm_acc_gt-glco-postgres"
          "--extra-py-files"     = local.extra_py.text
          "--target_table"       = "sdbtdir3_aprm_dbo.icext_glb_a_voice_output"
          "--folder_location"    = local.folder_aprm
          "--input_file_name"    = "ICEXT_GLB_A_VOICE_OUTPUT.TXT"
          "--delimiter_regex"    = "\\t"
          "--filter_record_type" = "ALL"
          "--valid_columns"      = local.aprm_acc_output_valid_columns
          "--skip_header_lines"  = "2"
        }
      )
    },
    {
      name              = "extract_3"
      description       = "APRM ACCRUAL Globe : SAP_REPORT_GLB_ACCRUAL.CSV → sdbtdir3_aprm_dbo.sap_report_glb_accrual"
      glue_version      = "5.1"
      worker_type       = var.glue_job_configs.worker_type
      number_of_workers = var.glue_job_configs.number_of_workers
      connections       = ["postgres"]
      tags              = { INGESTION_TYPE = "CSV", PIPELINE = "APRM ACCRUAL Globe" }

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
          "--TempDir"          = "s3://${local.bucket_name}/${local.aws_product_s3_prefix}/tmp/"
          "--connection_name"  = "${var.env_prefix}-aprm_acc_gt-glco-postgres"
          "--extra-py-files"   = local.extra_py_csv
          "--target_table"     = "sdbtdir3_aprm_dbo.sap_report_glb_accrual"
          "--folder_location"  = local.folder_aprm
          "--input_file_name"  = "SAP_REPORT_GLB_ACCRUAL.CSV"
          "--delimiter_regex"  = ","
          "--target_headers"   = local.aprm_acc_csv_target_headers
        }
      )
    }
  ]
}

module "glue_aprm_acc_ic" {
  source = "./modules/aws-glue"

  providers = {
    aws.environment = aws.environment,
    aws.security    = aws.security,
    aws.dr          = aws.dr,
    aws.security_dr = aws.security_dr
  }

  s3_bucket_name = ["storage", "scripts"]
  name           = "aprm_acc_ic"
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
      description       = "APRM ACCRUAL Innove : ICEXT_GLB_A_VOICE.txt → sdbtdir3_aprm_dbo.icext_inv_a_voice"
      glue_version      = "5.1"
      worker_type       = var.glue_job_configs.worker_type
      number_of_workers = var.glue_job_configs.number_of_workers
      connections       = ["postgres"]
      tags              = { INGESTION_TYPE = "TXT", PIPELINE = "APRM ACCRUAL Innove" }

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
          "--TempDir"            = "s3://${local.bucket_name}/${local.aws_product_s3_prefix}/tmp/"
          "--connection_name"    = "${var.env_prefix}-aprm_acc_ic-glco-postgres"
          "--extra-py-files"     = local.extra_py.text
          "--target_table"       = "sdbtdir3_aprm_dbo.icext_inv_a_voice"
          "--folder_location"    = local.folder_aprm
          "--input_file_name"    = "ICEXT_INV_A_VOICE.txt"
          "--delimiter_regex"    = "\\t"
          "--filter_record_type" = "ALL"
          "--expected_columns"   = "30"
          "--col_label"          = "column"
        }
      )
    },
    {
      name              = "extract_2"
      description       = "APRM ACCRUAL Innove : ICEXT_INV_A_VOICE_OUTPUT.TXT → sdbtdir3_aprm_dbo.icext_inv_a_voice_output"
      glue_version      = "5.1"
      worker_type       = var.glue_job_configs.worker_type
      number_of_workers = var.glue_job_configs.number_of_workers
      connections       = ["postgres"]
      tags              = { INGESTION_TYPE = "TXT_COLUMNED", PIPELINE = "APRM ACCRUAL Innove" }

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
          "--TempDir"            = "s3://${local.bucket_name}/${local.aws_product_s3_prefix}/tmp/"
          "--connection_name"    = "${var.env_prefix}-aprm_acc_ic-glco-postgres"
          "--extra-py-files"     = local.extra_py.text
          "--target_table"       = "sdbtdir3_aprm_dbo.icext_inv_a_voice_output"
          "--folder_location"    = local.folder_aprm
          "--input_file_name"    = "ICEXT_INV_A_VOICE_OUTPUT.TXT"
          "--delimiter_regex"    = "\\t"
          "--filter_record_type" = "ALL"
          "--valid_columns"      = local.aprm_acc_output_valid_columns
          "--skip_header_lines"  = "2"
        }
      )
    },
    {
      name              = "extract_3"
      description       = "APRM ACCRUAL Innove : SAP_REPORT_INV_ACCRUAL.CSV → sdbtdir3_aprm_dbo.sap_report_inv_accrual"
      glue_version      = "5.1"
      worker_type       = var.glue_job_configs.worker_type
      number_of_workers = var.glue_job_configs.number_of_workers
      connections       = ["postgres"]
      tags              = { INGESTION_TYPE = "CSV", PIPELINE = "APRM ACCRUAL Innove" }

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
          "--TempDir"          = "s3://${local.bucket_name}/${local.aws_product_s3_prefix}/tmp/"
          "--connection_name"  = "${var.env_prefix}-aprm_acc_ic-glco-postgres"
          "--extra-py-files"   = local.extra_py_csv
          "--target_table"     = "sdbtdir3_aprm_dbo.sap_report_inv_accrual"
          "--folder_location"  = local.folder_aprm
          "--input_file_name"  = "SAP_REPORT_INV_ACCRUAL.CSV"
          "--delimiter_regex"  = ","
          "--target_headers"   = local.aprm_acc_csv_target_headers
        }
      )
    }
  ]
}

module "glue_aprm_acc" {
  source = "./modules/aws-glue"

  providers = {
    aws.environment = aws.environment,
    aws.security    = aws.security,
    aws.dr          = aws.dr,
    aws.security_dr = aws.security_dr
  }

  s3_bucket_name = ["storage", "scripts"]
  name           = "aprm_acc"
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
      description       = "APRM ACCRUAL : Prime_Accumulated_Usage.csv → sdbtdir3_aprm_dbo.Prime_Accumulated_Usage"
      glue_version      = "5.1"
      worker_type       = "G.8X"
      number_of_workers = var.glue_job_configs.number_of_workers
      connections       = ["postgres"]
      tags              = { INGESTION_TYPE = "CSV", PIPELINE = "APRM ACCRUAL" }

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
          "--TempDir"         = "s3://${local.bucket_name_storage}/${local.aws_product_s3_prefix}/tmp/"
          "--user-jars-first" = "true"
          "--connection_name" = "${var.env_prefix}-aprm_acc-glco-postgres"
          "--extra-py-files"  = local.extra_py_csv
          "--target_table"    = "sdbtdir3_aprm_dbo.prime_accumulated_usage"
          "--folder_location" = local.folder_aprm
          "--input_file_name" = "Prime_Accumulated_Usage.csv"
          "--delimiter_regex" = ","
          "--target_headers"  = local.aprm_acc_prime_target_headers
        }
      )
    },
    {
      name              = "extract_2"
      description       = "APRM ACCRUAL : AUR Extract FINAL_BILLING.xlsx → sdbtdir3_aprm_dbo.AUR_Extract_FinalBilling"
      glue_version      = "4.0"
      worker_type       = "G.8X"
      number_of_workers = var.glue_job_configs.number_of_workers
      connections       = ["postgres"]
      tags              = { INGESTION_TYPE = "EXCEL_COLUMN_HEADED_NUMBERED", PIPELINE = "APRM ACCRUAL" }

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
          "--TempDir"          = "s3://${local.bucket_name_storage}/${local.aws_product_s3_prefix}/tmp/"
          "--user-jars-first"  = "true"
          "--connection_name"  = "${var.env_prefix}-aprm_acc-glco-postgres"
          "--extra-py-files"   = local.extra_py.spreadsheet
          "--extra-jars"       = local.extra_jars
          "--target_table"     = "sdbtdir3_aprm_dbo.aur_extract_finalbilling"
          "--folder_location"  = local.folder_aprm
          "--input_file_name"  = "AUR Extract FINAL_BILLING.xlsx"
          "--row_number_label" = "zrownumber"
          "--target_headers"   = local.aprm_acc_prime_target_headers
        }
      )
    }
  ]
}
