
variable "project_name" {
  type        = string
  description = ""
}

variable "env" {
  type        = string
  description = ""
}

variable "bucket_name" {
  type        = string
  description = ""
}

variable "account_id" {
  type        = string
  description = ""
}


variable "kms_key_arn" {
  type        = string
  description = ""
}

variable "confidentality" {
  type        = string
  description = "confidentality"
}

variable "compliance" {
  type        = string
  description = "compliance"
}
variable "cost_center" {
  type        = string
  description = "cost_center"
}

variable "account_name" {
  type        = string
  description = "account name"

}

variable "owner" {
  type        = string
  description = "sandbox"
}

variable "domain" {
  type        = string
  description = "domain"
}

variable "custom_bucket_policy" {
  type        = string
  description = "custom bucket policy"
}

variable "s3_folders" {
  type        = list(string)
  description = "s3 folders"
  default     = ["das/raw/", "das/standardized/"]
}

