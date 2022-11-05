locals {
  vpc_id                    = "vpc-0db91010bc2edd838"
  region                    = "ap-southeast-1"
  cluster_name              = "hasura-test"
  subnets                   = ["subnet-02798443503b458a1", "subnet-0e7184336cd43f3c2", "subnet-0d43cde4f0351facf"]
  cluster_enabled_log_types = []
  asg_desired_capacity      = 1
  asg_max_size              = 3
  asg_min_size              = 1
  instance_type             = "t2.micro"
}

provider "aws" {
  region = local.region
}

data "aws_eks_cluster" "cluster" {
  name = module.eks-cluster.cluster_id
}

data "aws_eks_cluster_auth" "cluster" {
  name = module.eks-cluster.cluster_id
}

provider "kubernetes" {
  host                   = data.aws_eks_cluster.cluster.endpoint
  cluster_ca_certificate = base64decode(data.aws_eks_cluster.cluster.certificate_authority.0.data)
  token                  = data.aws_eks_cluster_auth.cluster.token
  // load_config_file       = false
  version                = "~> 2.0.2"
}


module "eks-cluster" {
  source          = "terraform-aws-modules/eks/aws"
  version         = "14.0.0"
  cluster_name    = local.cluster_name
  cluster_version = "1.20"
  subnets         = local.subnets
  vpc_id          = local.vpc_id
  worker_groups = [
    {
      asg_desired_capacity = local.asg_desired_capacity
      asg_max_size         = local.asg_max_size
      asg_min_size         = local.asg_min_size
      instance_type        = local.instance_type
      name                 = "worker-group"
      additional_userdata  = "Worker group configurations"
      tags = [{
        key                 = "worker-group-tag"
        value               = "worker-group-1"
        propagate_at_launch = true
      }]
    }
  ]
  map_users = [
    {
      userarn  = "arn:aws:iam::xxxxxxxxx:user/test.user"
      username = "test.user"
      groups   = ["system:masters"]
    },
  ]
  cluster_enabled_log_types = local.cluster_enabled_log_types
  tags = {
    environment = "test"
  }
}
