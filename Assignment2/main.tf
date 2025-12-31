##########################
# 1️⃣ Provider
##########################
provider "aws" {
  shared_credentials_files = ["~/.aws/credentials"]
  shared_config_files      = ["~/.aws/config"]
}

##########################
# 4️⃣  Networking Module
##########################
module "networking" {
  source             = "./modules/networking"
  vpc_cidr_block     = var.vpc_cidr_block
  subnet_cidr_block  = var.subnet_cidr_block
  availability_zone  = var.availability_zone
  env_prefix         = var.env_prefix
}


##########################
# 4️⃣ Security Module
##########################
module "security" {
  source     = "./modules/security"
  vpc_id     = module.networking.vpc_id
  env_prefix = var.env_prefix
  my_ip      = local.my_ip
}
module "nginx_server" {
  source            = "./modules/webserver"
  env_prefix        = var.env_prefix
  instance_name     = "nginx-proxy"
  instance_type     = var.instance_type
  availability_zone = var.availability_zone
  vpc_id            = module.networking.vpc_id
  subnet_id         = module.networking.subnet_id
  security_group_id = module.security.nginx_sg_id
  public_key        = var.public_key
  script_path       = "./scripts/nginx-setup.sh"
  instance_suffix   = "nginx"
  common_tags       = local.common_tags
}
module "backend_servers" {
  for_each = { for idx, server in local.backend_servers : server.name => server }

  source            = "./modules/webserver"
  env_prefix        = var.env_prefix
  instance_name     = each.value.name
  instance_type     = var.instance_type
  availability_zone = var.availability_zone
  vpc_id            = module.networking.vpc_id
  subnet_id         = module.networking.subnet_id
  security_group_id = module.security.backend_sg_id
  public_key        = var.public_key
  script_path       = each.value.script_path
  instance_suffix   = each.value.suffix
  common_tags       = local.common_tags
}


########################################
# 5️⃣ Webserver Modules (Backend servers)
#########################################
module "backend_web1" {
  source            = "./modules/webserver"
  env_prefix        = var.env_prefix
  instance_name     = "web"
  instance_suffix   = local.backend_servers[0].suffix
  instance_type     = var.instance_type
  availability_zone = var.availability_zone
  vpc_id            = module.networking.vpc_id
  subnet_id         = module.networking.subnet_id
  security_group_id = module.security.backend_sg_id
  public_key        = var.public_key
  script_path       = local.backend_servers[0].script_path
  common_tags       = local.common_tags
}


module "backend_web2" {
  source            = "./modules/webserver"
  env_prefix        = var.env_prefix
  instance_name     = "web"
  instance_suffix   = local.backend_servers[1].suffix
  instance_type     = var.instance_type
  availability_zone = var.availability_zone
  vpc_id            = module.networking.vpc_id
  subnet_id         = module.networking.subnet_id
  security_group_id = module.security.backend_sg_id
  public_key        = var.public_key
  script_path       = local.backend_servers[1].script_path
  common_tags       = local.common_tags
}

module "backend_web3" {
  source            = "./modules/webserver"
  env_prefix        = var.env_prefix
  instance_name     = "web"
  instance_suffix   = local.backend_servers[2].suffix
  instance_type     = var.instance_type
  availability_zone = var.availability_zone
  vpc_id            = module.networking.vpc_id
  subnet_id         = module.networking.subnet_id
  security_group_id = module.security.backend_sg_id
  public_key        = var.public_key
  script_path       = local.backend_servers[2].script_path
  common_tags       = local.common_tags
}
