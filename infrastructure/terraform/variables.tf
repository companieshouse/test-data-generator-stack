variable "aws_region" {}
variable "aws_profile" {
  default = "development-eu-west-2"
}

variable "aws_bucket" {
  description = "The bucket used to store the terraform state files"
}

variable "remote_state_bucket" {
  description = "The bucket used to store the remote state files"
}

variable "state_prefix" {}
variable "workspace_key_prefix" {}
variable "state_file_name" {}

# These vpcs are configured for development. Preprod and prod are overridden in the vars file.
variable "vpc_cidr" {
  default = {
    eu-west-2 = "10.75.0.0/16" #London
  }
}

# Required for access from existing Concourse instances
variable "mgmt-eu-west-1_cidrs" {
  type    = list(string)
  default = ["10.50.17.0/24","10.50.19.0/24","10.50.21.0/24"]
}

# VPC ID read from terraform remote state.
variable "vpc_id" {
  default     = ""
}

variable "environment" {}
variable "internal_cidrs" {}
variable "deploy_to" {}

variable "docker_registry" {
  #default = "169942020521.dkr.ecr.eu-west-2.amazonaws.com" # dev
  default = "250991044064.dkr.ecr.eu-west-2.amazonaws.com" # staging        TODO - remove from here and set ay env level.
}
variable "app_version_test_data_generator" {
  #default = "test01"
  default = "0.1.2" # TODO - remove default to force version to be explicitly passed in
}

variable "docker_container_port" {
  default = "10000"
}

variable "ec2_key_pair_name" {
  description = "The name for the cluster."
}

variable "ec2_instance_type" {
  description = "The name for the autoscaling group for the cluster."
  default     = "t3.medium"
}

variable "ec2_image_id" {
  description = "The name for the autoscaling group for the ECS cluster."
  default     = "ami-007ef488b3574da6b" # ECS optimized Linux in London created 16/10/2019
}

variable "asg_max_instance_count" {
  description = "The name for the autoscaling group for the cluster."
  default     = 1
}

variable "asg_min_instance_count" {
  description = "The name for the autoscaling group for the cluster."
  default     = 1
}

variable "asg_desired_instance_count" {
  description = "The name for the autoscaling group for the cluster."
  default     = 1
}

variable "ssl_certificate_id" {}
variable "zone_id" {
  default = "" # default of empty string is used as conditional when creating route53 records i.e. if no zone_id provided then no route53
}
variable "top_level_domain" {}

variable "log_level" {
  description = "The log level for services to use: TRACE, DEBUG, INFO or ERROR"
  default     = "TRACE"
}

# Vault credentials read from environment
variable "VAULT_USERNAME" {}
variable "VAULT_PASSWORD" {}

//---------------- START: Environment Secrets for services ---------------------

variable "vault_secrets" {
  default = [ "secret_mongo_url" ]
  type = list(string)
}

//---------------- END: Environment Secrets for services ---------------------
