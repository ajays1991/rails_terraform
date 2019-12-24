/*====
Variables used across all modules
======*/
locals {
  production_availability_zones = ["us-east-1a", "us-east-1b"]
}

provider "aws" {
  region = var.region
  access_key = "AKIAJ5M6TSQGVWWHF2PQ"
  secret_key = "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"
  #profile = "duduribeiro"
}

resource "aws_key_pair" "key" {
  key_name   = "production_key"
  public_key = file("terraform_rsa.pub")
}

module "networking" {
  source               = "./modules/networking"
  environment          = "production"
  vpc_cidr             = "10.0.0.0/16"
  public_subnets_cidr  = ["10.0.1.0/24", "10.0.2.0/24"]
  private_subnets_cidr = ["10.0.10.0/24", "10.0.20.0/24"]
  region               = var.region
  availability_zones   = local.production_availability_zones
  key_name             = "production_key"
}

module "rds" {
  source            = "./modules/rds"
  environment       = "production"
  allocated_storage = "20"
  database_name     = var.production_database_name
  database_username = var.production_database_username
  database_password = var.production_database_password
  subnet_ids        = module.networking.private_subnets_id
  vpc_id            = module.networking.vpc_id
  instance_class    = "db.t2.micro"
}

module "ecs" {
  source             = "./modules/ecs"
  environment        = "production"
  vpc_id             = module.networking.vpc_id
  availability_zones = local.production_availability_zones
  repository_name    = "rails_terraform/production"
  subnets_ids        = module.networking.private_subnets_id
  public_subnet_ids  = module.networking.public_subnets_id
  security_groups_ids = concat([module.rds.db_access_sg_id], module.networking.security_groups_ids)
  database_endpoint = module.rds.rds_address
  database_name     = var.production_database_name
  database_username = var.production_database_username
  database_password = var.production_database_password
  secret_key_base   = var.production_secret_key_base
}

