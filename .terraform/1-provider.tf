terraform {
  required_providers {
    cloudflare = {
      source  = "cloudflare/cloudflare"
      version = "~> 4.0"
    }

    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }

  // Store state in S3
  backend "s3" {
    bucket         = "000-alshdavid-terraform-state"
    key            = "commbank-statement-converter/web/terraform.tfstate"
    region         = "ap-southeast-2"
    dynamodb_table = "000-alshdavid-terraform-state"
    encrypt        = true
  }
}

provider "aws" {
  region = "ap-southeast-2"
}

provider "cloudflare" {
}
