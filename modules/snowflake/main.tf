locals {
  stored_procedure_path = compact(flatten([
    [for procedure_name, procedure_path in var.sql_file_path : formatlist("%s", procedure_path)]
  ]))

}



resource "snowflake_warehouse" "dpa_snowflake_warehouse" {
  name           = var.dpa_snowflake_wh
  warehouse_size = "XSMALL"
  auto_suspend   = 1800
  auto_resume    = true
  comment        = "DPA Snowflake Warehouse"
}

resource "snowflake_database" "dpa_snowflake_database" {
  name    = var.dpa_snowflake_db
  comment = "DPA Snowflake Database"
}

resource "snowflake_schema" "dpa_snowflake_schema" {
  name     = var.schema_name
  database = snowflake_database.dpa_snowflake_database.name
}

resource "snowflake_role" "dpa_snowflake_role" {
  name    = var.dpa_snowflake_role
  comment = "DPA Snowflake Role"
}

resource "snowflake_grant_privileges_to_account_role" "dpa_grant_privileges_role" {
  account_role_name = snowflake_role.dpa_snowflake_role.name
  all_privileges    = true
  with_grant_option = true
  on_account_object {
    object_type = "DATABASE"
    object_name = snowflake_database.dpa_snowflake_database.name
  }

}

# resource "snowflake_procedure" "example_procedure" {
#   name        = "my_procedure"
#   database    = snowflake_database.dpa_snowflake_database.name
#   schema      = snowflake_schema.dpa_snowflake_schema.name
#   return_type = "STRING"
#   statement   = <<-EOT
#     CREATE OR REPLACE PROCEDURE my_procedure()
#     RETURNS STRING
#     LANGUAGE JAVASCRIPT
#     AS
#     $$
#     return 'Hello, World!';
#     $$
#   EOT
# }

# resource "snowflake_sql" "example_sql" {
#   database  = snowflake_database.dpa_snowflake_database.name
#   role      = snowflake_role.dpa_snowflake_role.name
#   warehouse = snowflake_warehouse.dpa_snowflake_warehouse.name

#   sql_text = <<-SQL
#     CREATE OR REPLACE PROCEDURE my_procedure()
#     RETURNS STRING
#     LANGUAGE JAVASCRIPT
#     AS
#     $$
#     return 'Hello, world!';
#     $$;

#     CALL my_procedure();
#   SQL
# }


# resource "snowflake_role_grants" "dpa_snowflake_role_grant" {
#   role_name = snowflake_role.dpa_snowflake_role.name
#   privilege = "CREATE DATABASE"
#   on        = "ACCOUNT"
# }

# resource "snowflake_user" "dpa_snowflake_user" {
#   name         = var.dpa_snowflake_user
#   login_name   = "dpa_snowflake_user_login"
#   password     = "your_password"
#   default_role = "ACCOUNTADMIN"
# }

resource "snowflake_stage" "dpa_snowflake_stage" {
  name     = "dpa-snowflake-stage-${var.dpa_snowflake_db}"
  url      = var.s3_bucket_url
  database = snowflake_database.dpa_snowflake_database.name
  schema   = snowflake_schema.dpa_snowflake_schema.name

}

# resource "snowflake_user_grant" "dpa_snowflake_user_grant" {
#   user_name = snowflake_user.dpa_snowflake_user.name
#   privilege = "CREATE DATABASE"
#   on        = "ACCOUNT"
# }


# resource "snowflake_storage_integration" "dpa_integration" {
#   name    = "var.integration_name"
#   comment = "A storage integration."
#   type    = "EXTERNAL_STAGE"

#   enabled = true

#   #   storage_allowed_locations = [""]
#   #   storage_blocked_locations = [""]
#   #   storage_aws_object_acl    = "bucket-owner-full-control"

#   storage_provider         = "S3"
#   storage_aws_external_id  = "..."
#   storage_aws_iam_user_arn = "..."
#   storage_aws_role_arn     = "..."


# }


resource "snowflake_storage_integration" "dpa_integration" {
  type                      = "EXTERNAL_STAGE"
  storage_provider          = "S3"
  enabled                   = true
  storage_aws_role_arn      = "arn:aws:iam::${var.aws_account_id}:role/${var.custom_aws_role_name}" # arn:aws:iam::my_user_account_id:role/my_role_name
  name                      = "dpa_snowflake_storage_integration-${var.dpa_snowflake_db}"
  comment                   = "A storage integration."
  storage_allowed_locations = [var.s3_bucket_url] # ["s3://dpa-sandbox-data-data-analytics-poc.s3.amazonaws.com/das/raw"]
}


# data "template_file" "sql_script" {
#   template = file("${var.sql_file_path}")
# }

data "template_file" "sql_script" {
  count = length(var.sql_file_path)

  #for_each = var.sql_file_path
  template = file("${var.sql_file_path[count.index]}")
}

# resource "snowflake_procedure" "execute_stored_procedure" {

#   database  = snowflake_database.dpa_snowflake_database.name
#   role      = snowflake_role.dpa_snowflake_role.name
#   warehouse = snowflake_warehouse.dpa_snowflake_warehouse.name

#   sql_text = data.template_file.sql_script.rendered

# }


resource "snowflake_procedure" "dpa_snowflake_procedure" {
  #count = length(var.sql_file_path)
  #name        = "dpa_procedure_${var.sql_file_path[count.index]}"
  #name        = "dpa_procedure" + [count.index]
  #for_each = toset(var.sql_file_path)

  count = length(var.sql_file_path)
  name  = "dpa_procedure${count.index}"
  # name = compact(flatten([
  #   [for var, path in var.sql_file_path : formatlist("dpa_procedure%s", path)]
  # ]))
  database    = snowflake_database.dpa_snowflake_database.name
  schema      = snowflake_schema.dpa_snowflake_schema.name
  return_type = "STRING"
  # statement   = join(",", data.template_file.sql_script.*.rendered) # data.template_file.sql_script[count.index].rendered
  statement = element(data.template_file.sql_script.*.rendered, count.index)
  #statement = data.template_file.sql_script[count.index].rendered
  # statement = compact(flatten([
  #   [for value in count.index : formatlist("data.template_file.sql_script.*.rendered", each.value)]
  # ]))

}
