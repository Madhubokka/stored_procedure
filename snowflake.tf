# data "template_file" "snowflakedb" {
#   template = file("./snowflake_input.json")

# }
# locals {
#   instance = data.template_file.snowflakedb
# }

locals {
  # get json 
  user_data = jsondecode(file("./backstage_variable.json"))

  # get all users
  warehouse_names      = distinct([for object in local.user_data.objectList : object.warehouse_name])
  database_names       = distinct([for object in local.user_data.objectList : object.database_name])
  schema_names         = distinct([for object in local.user_data.objectList : object.schema_name])
  dpa_snowflake_roles  = distinct([for object in local.user_data.objectList : object.dpa_snowflake_role])
  s3_bucket_url        = distinct([for object in local.user_data.objectList : object.s3_bucket_url])
  custom_aws_role_name = distinct([for object in local.user_data.objectList : object.custom_aws_role_name])
  aws_account_id       = distinct([for object in local.user_data.objectList : object.aws_account_id])

  #project_name,env,domain,3_bucket_url


  stored_procedure_files = {
    "stored_procedure"  = ["./stored_procedure.sql", ]
    "stored_procedure1" = ["./stored_procedure1.sql", ]
    "stored_procedure2" = ["./stored_procedure2.sql", ]
  }

}


module "dpa_poc_snowflake" {
  source = "./modules/snowflake"
  #for_each = data.template_file.snowflakedb
  #count            = length(var.warehouse_name)
  count            = length(local.database_names)
  dpa_snowflake_wh = local.warehouse_names[count.index]
  dpa_snowflake_db = local.database_names[count.index]
  schema_name      = local.schema_names[count.index]
  #dpa_snowflake_user = var.snowflake_user
  snowflake_role     = var.snowflake_role
  dpa_snowflake_role = local.dpa_snowflake_roles[count.index]
  env                = var.env
  project_name       = var.project_name
  confidentality     = var.confidentality
  compliance         = var.compliance
  cost_center        = var.cost_center
  owner              = var.owner
  account_name       = var.account_name
  kms_key_arn        = aws_kms_key.dpa-kms-for-s3.arn
  domain             = var.domain
  s3_bucket_url      = element(local.s3_bucket_url[*], count.index)
  #s3_bucket_url       = module.dpa_poc_bucket[0].s3_bucket_website_endpoint # "https://${var.project_name}-${var.env}-${var.domain}-data-analytics-poc.s3.amazonaws.com"
  #s3_bucket_url = "s3://${var.project_name}-${var.env}-${var.domain}-${var.dpa_bucket_name[0]}.s3.amazonaws.com/das/raw"
  # https://dpa-sandbox-data-data-analytics-poc.s3.amazonaws.com/das/raw/
  # https//dpa-sandbox-datapattern-data-analytics-poc.s3.amazonaws.com/das/raw
  custom_aws_role_name = local.custom_aws_role_name[count.index]
  aws_account_id       = element(local.aws_account_id[*], count.index)
  #sql_file_path       = local.stored_procedure_files
  sql_file_path = ["./stored_procedure.sql", "./stored_procedure1.sql", "./stored_procedure2.sql"]
  # sql_file_path = {
  #   procedure0 = "./stored_procedure.sql",
  #   procedure1 = "./stored_procedure1.sql",
  #   procedure2 = "./stored_procedure2.sql"
  # }
  depends_on = [module.dpa_poc_bucket, module.dpa_poc_iam]
}


# resource "aws_iam_role" "dpa-snowflake-s3-storage-access-role" {
#   #count = length(var.warehouse_name)
#   #depends_on = [module.dpa_poc_snowflake]
#   name       = "${var.project_name}-${var.env}-s3-access-role"
#   path       = "/service-role/"
#   assume_role_policy = jsonencode({
#     "Version" : "2012-10-17",
#     "Statement" : [{
#       "Effect" : "Allow",
#       "Principal" : {
#         #"AWS" : "arn:aws:iam::531831388604:user/q8jj0000-s"
#         "AWS" : "${module.dpa_poc_snowflake.storage_user_arn}"
#       },
#       "Action" : "sts:AssumeRole",
#       "Sid" : ""
#       "Condition" : {
#         "StringEquals" : {
#           #"sts:ExternalId" : "TT96852_SFCRole=2_xwSf5E4dGHJpEp4idwujQZnWoDo="
#           "sts:ExternalId" : "${module.dpa_poc_snowflake.storage_external_id}"
#         }
#       }
#     }]
#   })

# }



# resource "aws_iam_role" "dpa-snowflake-s3-storage-access-role" {
#   #count = length(var.warehouse_name)
#   #depends_on = [snowflake_storage_integration.dpa_integration]
#   name = "${var.project_name}-${var.env}-s3-access-role"
#   assume_role_policy = jsonencode({
#     Version = "2012-10-17"
#     Statement = [
#       {
#         Action = "sts:AssumeRole"
#         Effect = "Allow"
#         Sid    = ""
#         Principal = {
#           "AWS" : "*"
#           #AWS = module.dpa_poc_snowflake.storage_user_arn
#         }
#         Condition = {
#           "StringEquals" : {
#             "sts:ExternalId" : "*"
#             #"sts:ExternalId" = module.dpa_poc_snowflake.storage_external_id
#           }
#         }
#       },
#     ]
#   })
# }


# # resource "aws_iam_role" "dpa-snowflake-s3-storage-access-role" {
# #   #   #count = length(var.warehouse_name)
# #   #   #depends_on = [module.dpa_poc_snowflake]
# #   name               = "${var.project_name}-${var.env}-s3-access-role"
# #   assume_role_policy = data.aws_iam_policy_document.dpa_snowflake_role_policy.json
# # }


# resource "aws_iam_policy" "dpa-snowflake-s3-storage-access-policy" {
#   count       = length(var.dpa_bucket_name)
#   name        = "dpa_snowflake_s3_storage_access_policy${var.dpa_bucket_name[count.index]}"
#   description = "Allow read and write access to s3 bucket"
#   policy = jsonencode({
#     Version = "2012-10-17",
#     Statement = [
#       {
#         "Effect" : "Allow",
#         "Action" : [
#           "s3:Getobject", "s3:ListBucket", "s3:PutObject*"
#         ],
#         Resource = ["${module.dpa_poc_bucket[count.index].s3_bucket_arn}", "${module.dpa_poc_bucket[count.index].s3_bucket_arn}/*"]
#       }
#     ]
#   })
# }

# resource "aws_iam_role_policy_attachment" "dpa-snowflake-storage-policy-attachment" {
#   count      = length(var.dpa_bucket_name)
#   role       = aws_iam_role.dpa-snowflake-s3-storage-access-role.name
#   policy_arn = aws_iam_policy.dpa-snowflake-s3-storage-access-policy[count.index].arn
# }


