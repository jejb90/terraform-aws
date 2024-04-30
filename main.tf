provider "aws" {
  region = "us-east-1"
}

module "networking_production" {
  source = "./environments/production"
}

module "networking_development" {
  source = "./environments/development"
}