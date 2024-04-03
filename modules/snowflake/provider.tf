terraform {
  required_version = "<= 1.7.3" #Forcing which version of Terraform needs to be used
  required_providers {
    snowflake = {
      source  = "Snowflake-Labs/snowflake"
      version = "0.87.0"
    }
  }
}
