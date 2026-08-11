module "backend_app" {
  source = "./modules/composite/backend_app"

  name                = var.name
  cors_allow_origins  = var.cors_allow_origins
  lambdas_source_root = "${path.module}/../lambdas"
  common_source_dir   = "${path.module}/../lambdas/common"
  tags                = var.tags
}
