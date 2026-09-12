
module "s3_module" {
  # source = "globe.pe.jfrog.io/hmd-terraform-local__service/aws-s3/aws"
  source = "./modules/aws-s3"
  # version = "~>2.9.0"
  providers = {
    aws.environment = aws.environment,
    aws.security    = aws.security,
    aws.dr          = aws.dr
    aws.security_dr = aws.security_dr
  }

  name = "storage" # component_name
  #depends_on = [ module.esatp_service_account_eks ]
  allow_iam_admin = [var.irsa_name]
  
  # cross_replication_from = [
  #  {
  #    accountID = "123456789" #source AWS accountID
  #    rolename = "s3crr_role_for_samplebucket" #source IAM role used in replication configuration
  #  }
  # ]

  #cors_rule_configuration = [
  #  {
  #    allowed_headers = ["Authorization"]
  #    allowed_methods = ["GET"]
  #    allowed_origins = ["https://bulk-grcpt.globetel.cloud","https://portal-grcpt.globetel.cloud"]
  #    expose_headers  = ["ETag"]
  #    max_age_seconds = 3600
  #  },
  #  {
  #    allowed_headers = ["Authorization"]
  #    allowed_methods = ["POST", "PUT"]
  #    allowed_origins = ["https://api-grcpt.globetel.cloud","https://portal-grcpt.globetel.cloud","https://reports-grcpt.globetel.cloud"]
  #    expose_headers  = ["ETag"]
  #    max_age_seconds = 4000
  #  },
  #  {
  #    allowed_methods = ["POST", "PUT"]
  #    allowed_origins = ["https://api-grcpt.globetel.cloud","https://portal-grcpt.globetel.cloud","https://reports-grcpt.globetel.cloud"]
  #  }
  # Add more CORS rules if needed
#]
      
  lifecycle_rules = [
    # {
    #   id      = "test-transition-class2"
    #   enabled = true
    #   transition = [{
    #     storage_class = "STANDARD_IA"
    #     days = 31
    #   }]
    # },
    # {
    #   id      = "test-all-blocks"
    #   enabled = true
    #   abort_incomplete_multipart_upload = {
    #     days_after_initiation = 26
    #   }
    #   expiration = {
    #       expired_object_delete_marker = true
    #   }
    #   filter = {
    #     prefix = "test"
    #   }
    #   noncurrent_version_expiration = {
    #     noncurrent_days = 111
    #     newer_noncurrent_versions = 36
    #   }
    #   noncurrent_version_transition = [{
    #     storage_class = "STANDARD_IA"
    #     noncurrent_days = 30
    #   },
    #   {
    #     storage_class = "ONEZONE_IA"
    #     noncurrent_days = 60
    #   },
    #   {
    #     storage_class = "GLACIER"
    #     noncurrent_days = 100
    #   }
    #   ]
    #   transition = [{
    #     storage_class = "STANDARD_IA"
    #     days = 30
    #   },
    #   {
    #     storage_class = "ONEZONE_IA"
    #     days = 60
    #   },
    #   {
    #     storage_class = "GLACIER"
    #     days = 100
    #   }
    #   ]
    # },
    {
      id      = "esatp-file-life-cycle"
      enabled = false
      abort_incomplete_multipart_upload = {
        days_after_initiation = 26
      }
      expiration = {
          expired_object_delete_marker = true
      }
      # noncurrent_version_expiration = {
      #   noncurrent_days = 101
      #   newer_noncurrent_versions = 36
      # }
      # noncurrent_version_transition = [{
      #   storage_class = "STANDARD_IA"
      #   noncurrent_days = 30
      # },
      # {
      #   storage_class = "ONEZONE_IA"
      #   noncurrent_days = 60
      # },
      # {
      #   storage_class = "GLACIER"
      #   noncurrent_days = 100
      # }
      # ]
      transition = [{
        storage_class = "STANDARD_IA"
        days = 1095
      },
      {
        storage_class = "ONEZONE_IA"
        days = 1825
      },
      {
        storage_class = "GLACIER"
        days = 3650
      }
      ]
    }
  ]
}

module "s3_module_2" {
  # source = "globe.pe.jfrog.io/hmd-terraform-local__service/aws-s3/aws"
  source = "./modules/aws-s3"
  # version = "~>2.9.0"
  providers = {
    aws.environment = aws.environment,
    aws.security    = aws.security,
    aws.dr          = aws.dr
    aws.security_dr = aws.security_dr
  }

  name = "scripts" # component_name
  #depends_on = [ module.esatp_service_account_eks ]
  allow_iam_admin = [var.irsa_name]
  
  # cross_replication_from = [
  #  {
  #    accountID = "123456789" #source AWS accountID
  #    rolename = "s3crr_role_for_samplebucket" #source IAM role used in replication configuration
  #  }
  # ]

  #cors_rule_configuration = [
  #  {
  #    allowed_headers = ["Authorization"]
  #    allowed_methods = ["GET"]
  #    allowed_origins = ["https://bulk-grcpt.globetel.cloud","https://portal-grcpt.globetel.cloud"]
  #    expose_headers  = ["ETag"]
  #    max_age_seconds = 3600
  #  },
  #  {
  #    allowed_headers = ["Authorization"]
  #    allowed_methods = ["POST", "PUT"]
  #    allowed_origins = ["https://api-grcpt.globetel.cloud","https://portal-grcpt.globetel.cloud","https://reports-grcpt.globetel.cloud"]
  #    expose_headers  = ["ETag"]
  #    max_age_seconds = 4000
  #  },
  #  {
  #    allowed_methods = ["POST", "PUT"]
  #    allowed_origins = ["https://api-grcpt.globetel.cloud","https://portal-grcpt.globetel.cloud","https://reports-grcpt.globetel.cloud"]
  #  }
  # Add more CORS rules if needed
#]
      
  lifecycle_rules = [
    # {
    #   id      = "test-transition-class2"
    #   enabled = true
    #   transition = [{
    #     storage_class = "STANDARD_IA"
    #     days = 31
    #   }]
    # },
    # {
    #   id      = "test-all-blocks"
    #   enabled = true
    #   abort_incomplete_multipart_upload = {
    #     days_after_initiation = 26
    #   }
    #   expiration = {
    #       expired_object_delete_marker = true
    #   }
    #   filter = {
    #     prefix = "test"
    #   }
    #   noncurrent_version_expiration = {
    #     noncurrent_days = 111
    #     newer_noncurrent_versions = 36
    #   }
    #   noncurrent_version_transition = [{
    #     storage_class = "STANDARD_IA"
    #     noncurrent_days = 30
    #   },
    #   {
    #     storage_class = "ONEZONE_IA"
    #     noncurrent_days = 60
    #   },
    #   {
    #     storage_class = "GLACIER"
    #     noncurrent_days = 100
    #   }
    #   ]
    #   transition = [{
    #     storage_class = "STANDARD_IA"
    #     days = 30
    #   },
    #   {
    #     storage_class = "ONEZONE_IA"
    #     days = 60
    #   },
    #   {
    #     storage_class = "GLACIER"
    #     days = 100
    #   }
    #   ]
    # },
    {
      id      = "esatp-file-life-cycle2"
      enabled = false
      abort_incomplete_multipart_upload = {
        days_after_initiation = 26
      }
      expiration = {
          expired_object_delete_marker = true
      }
      # noncurrent_version_expiration = {
      #   noncurrent_days = 101
      #   newer_noncurrent_versions = 36
      # }
      # noncurrent_version_transition = [{
      #   storage_class = "STANDARD_IA"
      #   noncurrent_days = 30
      # },
      # {
      #   storage_class = "ONEZONE_IA"
      #   noncurrent_days = 60
      # },
      # {
      #   storage_class = "GLACIER"
      #   noncurrent_days = 100
      # }
      # ]
      transition = [{
        storage_class = "STANDARD_IA"
        days = 1095
      },
      {
        storage_class = "ONEZONE_IA"
        days = 1825
      },
      {
        storage_class = "GLACIER"
        days = 3650
      }
      ]
    }
  ]
}