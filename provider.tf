#This Terraform Code Deploys Basic VPC Infra.
provider "aws" {
  region = var.region
  #profile = "default" #AWS Credentials Profile (profile = "default") configured on local
  access_key = var.access_key
  secret_key = var.secret_key
}


terraform {
  required_version = "<= 1.7.3" #Forcing which version of Terraform needs to be used
  required_providers {
    aws = {
      version = "<= 5.37.0" #Forcing which version of plugin needs to be used.
      source  = "hashicorp/aws"
    }
    snowflake = {
      source  = "Snowflake-Labs/snowflake"
      version = "0.87.0"
    }
  }
}


provider "snowflake" {
  account  = var.dpa_snowflake_account_name
  user     = var.dpa_snowflake_username
  password = var.dpa_snowflake_password
  role     = var.snowflake_role
}
