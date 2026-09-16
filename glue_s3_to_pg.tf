module "glue_extract_s3pg" {
  source = "./modules/aws-glue"

  providers = {
    aws.environment = aws.environment,
    aws.security    = aws.security,
    aws.dr          = aws.dr,
    aws.security_dr = aws.security_dr
  }

  #depends_on = [ module.s3_module,module.s3_module_2 ]

  s3_bucket_name     = ["storage","scripts"]

  name = "s3_to_pg"

  sns_topic_name = null
  
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

      glue_job_command  = [
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
        "--TempDir"          = "s3://${local.bucket_name}/${local.aws_product_s3_prefix}/tmp/"
        "--user-jars-first"  = "true"
        "--s4_table_name"    = "aufk"
        "--pg_table_name"    = "dgs4hana_tdir1_dbo.aufk"
        "--input_file_name"  = "s3://${local.bucket_name_storage}/from_SAP/aufk_output.csv"
        "--extra-jars"       = "s3://${local.bucket_name}/${local.aws_product_s3_prefix}/${local.commons_s3_prefix}/artifacts/ngdbc-2.29.7.jar,s3://${local.bucket_name}/${local.aws_product_s3_prefix}/${local.commons_s3_prefix}/artifacts/postgresql-42.7.13.jar"
       }             
      )
    }    

  ]


}