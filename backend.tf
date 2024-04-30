terraform {
  backend "s3" {
    bucket         = "terraform-prod-dev-aws-infra"
    key            = "terraform/state"
    region         = "us-east-1"
    dynamodb_table = "my-terraform-lock-table"
    encrypt        = true
  }
}

terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}
