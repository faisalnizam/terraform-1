#
# MAINTAINER Vitaliy Natarov "vitaliy.natarov@yahoo.com"
#

terraform {
  required_version = "~> 0.13.5"
}

provider "aws" {
  region                  = "us-east-1"
  profile                 = "default"
  shared_credentials_file = pathexpand("~/.aws/credentials")
}

##############################################################
## ECS Cluster
##############################################################
module "ecs_cluster" {
  source      = "../../modules/ecs"
  environment = "nonprod"

  enable_ecs_cluster = true
  ecs_cluster_name   = "jenkins-slave-nonprod"
  setting = [
    {
      name  = "containerInsights",
      value = "enabled"
    }
  ]

  tags = map("Env", "stage", "Orchestration", "Terraform")
}

##############################################################
## ECS task definition
##############################################################
module "ecs_task_definition" {
  source      = "../../modules/ecs"
  environment = "nonprod"
  name        = "jenkins-slave"

  enable_ecs_task_definition = true
  family                     = "jenkins-slave-service-nonprod"
  container_definitions      = file("./additional_files/ecs/container_definitions.json")

  task_role_arn      = "arn:aws:iam::666666666666:role/jenkins-master-nonprod"
  execution_role_arn = "arn:aws:iam::666666666666:role/jenkins-slave-nonprod"
  network_mode       = "bridge"
  ipc_mode           = "host"
  pid_mode           = "task"

  volume = [
    {
      name      = "jenkins-slave-volume-nonprod"
      host_path = "/ecs/jenkins-slave-volume-nonprod"
    },
  ]

  placement_constraints = [
    {
      type       = "memberOf"
      expression = "attribute:ecs.availability-zone in [us-east-2a, us-east-2b, us-east-2c]"
    },
  ]

  tags = map("Env", "stage", "Orchestration", "Terraform")
}

##############################################################
## ECS service
##############################################################
module "ecs_service" {
  source      = "../../modules/ecs"
  environment = "nonprod"

  enable_ecs_service = true
  ecs_service_name   = "jenkins-slave-service-nonprod"

  ecs_cluster_id  = module.ecs_cluster.ecs_cluster_id
  task_definition = module.ecs_task_definition.ecs_task_definition_arn
  desired_count   = 3
  iam_role        = ""

  launch_type         = "EC2"
  platform_version    = "LATEST"
  scheduling_strategy = "REPLICA"

  deployment_controller = [
    {
      type = "ECS"
    },
  ]

  #load_balancer                       = [
  #    {
  #        target_group_arn    = "alb"
  #        container_port      = 8080
  #    },
  #]

  ordered_placement_strategy = [
    {
      type  = "binpack"
      field = "cpu"
    },
  ]

  placement_constraints = [
    {
      type       = "memberOf"
      expression = "attribute:ecs.availability-zone in [us-east-2a, us-east-2b]"
    },
  ]

  tags = map("Env", "stage", "Orchestration", "Terraform")
}
