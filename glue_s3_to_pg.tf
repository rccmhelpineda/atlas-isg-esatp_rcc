module "glue_extract_s3pg" {
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
        source_secrets_manager_arn          = var.dbSecret
        source_secrets_manager_name         = var.dbSecretName
        source_secrets_manager_kms_key_arn = "*"
        
        connection_properties = {
          JDBC_CONNECTION_URL = "jdbc:postgresql://${var.dbInstance}:1769/${var.dbName}"
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
      worker_type       = "G.1X"
      number_of_workers = 5
      connections       = ["postgres"]
      tags              = { PIPELINE = "Test SAP to S3" }

      glue_job_command  = [
        {
          name            = "glueetl"
          python_version  = "3"
          script_location = "s3://${local.bucket_name}/${local.aws_product_s3_prefix}/testing/s3_to_postgres_test.py"
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
        "--s3_path"          = "s3://${local.bucket_name_storage}/test/test_output.csv"
        "--table_name"       = "dgs4hana_tdir1_dbo.aufk"
        "--extra-jars"       = "s3://${local.bucket_name}/${local.aws_product_s3_prefix}/core/commons/artifacts/ngdbc-2.29.7.jar,s3://${local.bucket_name}/${local.aws_product_s3_prefix}/core/commons/artifacts/postgresql-42.7.13.jar"
       }             
      )
    }    

  ]


}