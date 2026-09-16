###
module "glue_etl" {
  source = "./modules/aws-glue"

  providers = {
    aws.environment = aws.environment,
    aws.security    = aws.security,
    aws.dr          = aws.dr,
    aws.security_dr = aws.security_dr
  }

  #depends_on = [ module.s3_module,module.s3_module_2 ]

  s3_bucket_name     = [""]
  name = "glue_etl"
  sns_topic_name = ""

  glue_jobs = [
    {
        name = "tst-s3"
        worker_type = var.glue_job_configs.worker_type
        number_of_workers  = var.glue_job_configs.number_of_workers
        glue_version       = var.glue_job_configs.glue_version
        execution_class    = var.glue_job_configs.execution_class
        glue_job_command = [
            {
            script_location = "s3://${var.glue_job_configs.glue_bucket_name}/glue/testing/upload_to_s3.py"
            python_version  = "3"
            name = "glueetl"
            }
        ]
        default_arguments = var.glue_job_configs.default_arguments
    },
    {
        name = "tst-sapdb"
        worker_type = var.glue_job_configs.worker_type
        number_of_workers  = var.glue_job_configs.number_of_workers
        glue_version       = var.glue_job_configs.glue_version
        execution_class    = var.glue_job_configs.execution_class
        glue_job_command = [
            {
            script_location = "s3://${var.glue_job_configs.glue_bucket_name}/glue/testing/connectivity_to_SAP_DB_server.py"
            python_version  = "3"
            name = "glueetl"
            }
        ]
        default_arguments = var.glue_job_configs.default_arguments
    }

  ]

}