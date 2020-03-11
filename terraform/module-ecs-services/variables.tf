variable "stack_name" {}
variable "name_prefix" {}
variable "environment" {}

variable "docker_registry" {}
variable "release_version" {}
variable "docker_container_port" {}

variable "application_ids" {}
variable "web_access_cidrs" {}
variable "aws_region" {}
variable "vpc_id" {}

variable "ssl_certificate_id" {}
variable "zone_id" {}
variable "external_top_level_domain" {}
variable "internal_top_level_domain" {}

variable "ecs_cluster_id" {}

variable "task_execution_role_arn" {}

variable "log_level" {}

//---------------- START: Environment Secrets for services ---------------------

variable "secrets_arn_map" {
  type = map(string)
  description = "The ARNs for all secrets"
}

//---------------- END: Environment Secrets for services ---------------------