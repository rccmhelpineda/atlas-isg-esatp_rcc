terraform {
  required_version = ">= 1.5.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

# Sandbox-only. Do not copy to client. Default AWS profile is not RCC.
provider "aws" {
  region  = "us-east-1"
  profile = "rcc-mhel"
}

# Alias providers required by the client module signatures,
# mapping all aliases directly to the sandbox AWS account:
provider "aws" {
  alias   = "environment"
  region  = "us-east-1"
  profile = "rcc-mhel"
}

provider "aws" {
  alias   = "security"
  region  = "us-east-1"
  profile = "rcc-mhel"
}

provider "aws" {
  alias   = "dr"
  region  = "us-east-1"
  profile = "rcc-mhel"
}

provider "aws" {
  alias   = "security_dr"
  region  = "us-east-1"
  profile = "rcc-mhel"
}

provider "aws" {
  alias   = "route53"
  region  = "us-east-1"
  profile = "rcc-mhel"
}

provider "aws" {
  alias   = "instance_scheduler"
  region  = "us-east-1"
  profile = "rcc-mhel"
}
