module "glue_extract_sap" {
  # source = "globe.pe.jfrog.io/hmd-terraform-local__service/aws-glue/aws"
  source = "./modules/aws-glue"
  # version = "~>1.5.1"

  providers = {
    aws.environment = aws.environment,
    aws.security    = aws.security,
    aws.dr          = aws.dr,
    aws.security_dr = aws.security_dr
  }

  #depends_on = [ module.s3_module,module.s3_module_2 ]

  s3_bucket_name     = ["storage","scripts"]

  name = "sap_to_s3"

  sns_topic_name = null
  
  source_secrets_manager_arn          = var.dbSecretSAP
  source_secrets_manager_name         = var.dbSecretNameSAP
  source_secrets_manager_kms_key_arn = "*"

 
  glue_connections = [
    {
        name            = "sapdb"
        description     = "JDBC connection to S4Hana database"
        connection_type = "JDBC"
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
      worker_type       = "G.1X"
      connections       = ["sapdb"]
      number_of_workers = 5

      tags              = { PIPELINE = "Test SAP to S3" }

      glue_job_command  = [
        {
          name            = "glueetl"
          python_version  = "3"
          script_location = "s3://${local.bucket_name}/${local.aws_product_s3_prefix}/core/testing/sap_to_s3_test.py"
        }
      ]

      execution_property = {
        max_concurrent_runs = 3
      }

      default_arguments = merge(
        var.glue_job_configs.default_arguments,
        {
        "--TempDir"          = "s3://${local.bucket_name}/${local.aws_product_s3_prefix}/tmp/"
        "--user-jars-first"  = "true"
        "--secret_name"      = var.dbSecretNameSAP
        "--jdbc_url"         = "jdbc:sap://${var.dbHostSAP}:${var.dbPortSAP}/"
        "--s3_target_path"   = "s3://${local.bucket_name_storage}/SAP_tmp"
        "--extra-jars"       = "s3://${local.bucket_name}/${local.aws_product_s3_prefix}/core/commons/artifacts/ngdbc-2.29.7.jar,s3://${local.bucket_name}/${local.aws_product_s3_prefix}/core/commons/artifacts/postgresql-42.7.13.jar"
        "--table_name"      = "SAPPRD.AUFK"
        "--final_file_name" = "from_SAP/for_ingestion/aufk_output.csv"
        }             
      )
    }

  ]


}