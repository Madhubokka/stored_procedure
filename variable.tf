variable "region" {
  type    = string
  default = "us-east-1"
}

variable "access_key" {
  type = string
}

variable "secret_key" {
  type = string
}

variable "project_name" {
  type        = string
  description = "Project name"
  default     = "dpa"

}

variable "env" {
  type        = string
  description = "sandbox"
  default     = "sandbox"
}


variable "confidentality" {
  type        = string
  description = "confidentality"
  default     = "public"
}

variable "compliance" {
  type        = string
  description = "sandbox"
  default     = "none"
}
variable "cost_center" {
  type        = string
  description = "sandbox"
  default     = "6000909"
}


variable "owner" {
  type        = string
  description = "sandbox"
  default     = "data"
}
variable "account_name" {
  type        = string
  description = "data-analysis-team"
  default     = "s_test_user"
}

variable "admin_username" {
  type        = string
  default     = "practice_user"
  description = "admin usernam"
}

variable "domain" {
  type        = string
  description = "domain"
  default     = "datapattern"
}

variable "account_id" {
  type        = string
  description = ""
  default     = "905418290423"
}

variable "user_access" {
  type        = string
  description = "user access"
  default     = "practice_user"
}


variable "s3_folders" {
  type        = list(string)
  description = "s3 folders"
  default     = ["das/raw/", "das/standardized/"]
}

variable "user_arn" {
  default = "arn:aws:iam::047109936880:user/khong-aol"
}

variable "key_spec" {
  default = "SYMMETRIC_DEFAULT"
}

variable "enabled" {
  default = true
}

variable "rotation_enabled" {
  default = true
}

variable "admin_rolename" {
  default = "s3_admin_role"
}


variable "dpa_snowflake_account_name" {
  type = string
}

variable "dpa_snowflake_username" {
  type = string

}

variable "dpa_snowflake_password" {
  type = string

}

variable "warehouse_name" {
  #type    = list(string)
  #default = ["DPA-WAH-POC-1", "DPA-WAH-POC-2"]
  type    = string
  default = "DPA-WAH-POC"
}
variable "database_name" {
  #type    = list(string)
  #default = ["DPA-POC-1", "DPA-POC-2"]
  type    = string
  default = "DPA-POC"
}
variable "schema_name" {
  #ype    = list(string)
  #default = ["POCSNOW-1", "POCSNOW-2"]
  type    = string
  default = "POCSNOW"
}

variable "snowflake_role" {
  type    = string
  default = "ACCOUNTADMIN"
}

variable "dpa_snowflake_role" {
  #type    = list(string)
  #default = ["dpa-account-developer-1", "dpa-account-developer-2"]
  type    = string
  default = "vdpa-account-developer"
}

variable "dpa_bucket_name" {
  type    = list(string)
  default = ["data-analytics-poc", "data-analytics-poc-2", "data-analytics-poc-3", "data-analytics-poc-4"]
}

variable "dpa_snowflake_iam_role_name" {
  type    = list(string)
  default = []
}

