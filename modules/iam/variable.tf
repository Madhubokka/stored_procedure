# variable "dpa_bucket_name" {
#   type    = list(string)
#   default = []

# }

variable "project_name" {
  type        = string
  description = ""
}

variable "env" {
  type        = string
  description = ""
}

variable "s3_bucket_name" {
  type        = string
  description = ""
}

# variable "dpa_snowflake_iam_role_name" {
#   type = string
# }


# variable "role_sts_externalid" {
#   description = "STS ExternalId condition values to use with a role (when MFA is not required)"
#   type        = any
#   default     = []
# }


# variable "custom_role_trust_policy" {
#   description = "A custom role trust policy. (Only valid if create_custom_role_trust_policy = true)"
#   type        = string
#   default     = ""
# }

# variable "create_custom_role_trust_policy" {
#   description = "Whether to create a custom_role_trust_policy. Prevent errors with count, when custom_role_trust_policy is computed"
#   type        = bool
#   default     = false
# }

variable "role_name" {
  description = "IAM role name"
  type        = string
  default     = null
}

variable "role_name_prefix" {
  description = "IAM role name prefix"
  type        = string
  default     = null
}

variable "role_path" {
  description = "Path of IAM role"
  type        = string
  default     = "/"
}
