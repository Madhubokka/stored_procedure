variable "project_name" {
  type = string
}

variable "env" {
  type = string
}

variable "confidentality" {
  type = string
}

variable "compliance" {
  type = string
}

variable "cost_center" {
  type = string
}

variable "owner" {
  type = string
}

variable "account_name" {
  type = string
}

variable "kms_key_arn" {
  type = string
}

variable "dpa_snowflake_wh" {
  type = string
}

variable "dpa_snowflake_db" {
  type = string
}

variable "schema_name" {
  type = string
}

# variable "s3_stage" {
#   type = string
# }


variable "s3_bucket_url" {
  type = string
}

# variable "dpa_snowflake_user" {
#   type = string
# }

variable "dpa_snowflake_role" {
  type = string
}

variable "domain" {
  type = string
}

variable "snowflake_role" {
  type = string
}

variable "custom_aws_role_name" {
  type = string
}

# variable "sql_file_path" {
#   type        = string
#   description = "Path to the SQL file containing the stored procedure"
# }

variable "sql_file_path" {
  type        = list(string)
  description = "Path to the SQL file containing the stored procedure"
}

# variable "sql_file_path" {
#   type        = map(any)
#   description = "Path to the SQL file containing the stored procedure"
#   default     = {}
# }

# variable "sql_file_path" {
#   type        = any
#   description = "Path to the SQL file containing the stored procedure"
#   default     = {}
# }

variable "aws_account_id" {
  type        = string
  description = ""
}
