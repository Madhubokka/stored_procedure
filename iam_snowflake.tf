locals {
  # get json 
  iam_user_data = jsondecode(file("./backstage_iam_variable.json"))

  # get all users

  project_name                = distinct([for object in local.iam_user_data.iamobjectList : object.project_name])
  environment                 = distinct([for object in local.iam_user_data.iamobjectList : object.environment])
  dpa_snowflake_iam_role_name = distinct([for object in local.iam_user_data.iamobjectList : object.dpa_snowflake_iam_role_name])
  resource_names              = distinct([for object in local.iam_user_data.iamobjectList : object.resource_names])
  #   #project_name,env,domain,3_bucket_url

  #   project_name                = distinct([for object in local.user_data.objectList : object.project_name])
  #   environment                 = distinct([for object in local.user_data.objectList : object.environment])
  #   dpa_snowflake_iam_role_name = distinct([for object in local.user_data.objectList : object.dpa_snowflake_iam_role_name])
  #   resource_names              = distinct([for object in local.user_data.objectList : object.resource_names])

}


module "dpa_poc_iam" {
  source         = "./modules/iam"
  count          = length(local.dpa_snowflake_iam_role_name)
  project_name   = var.project_name
  env            = var.env
  role_name      = local.dpa_snowflake_iam_role_name[count.index]
  s3_bucket_name = element(local.resource_names[*], count.index)
  depends_on     = [module.dpa_poc_bucket]
}
