data "aws_caller_identity" "current" {}

module "eks_cluster" {
  source  = "git::https://github.com/terraform-aws-modules/terraform-aws-eks.git?ref=v20.10.0" # v20.10.0
  # version = "20.10.0"

  cluster_name    = var.cluster_name
  cluster_version = "1.31"

  create_cloudwatch_log_group = false

  vpc_id      = module.vpc.vpc_id
  subnet_ids  = module.vpc.private_subnets
  enable_irsa = true

  enable_cluster_creator_admin_permissions = true

  eks_managed_node_groups = {
    default = {
      desired_size = 1
      max_size     = 2
      min_size     = 1

      instance_types = ["t3.small"]

      iam_role_additional_policies = {
        AmazonEKSWorkerNodePolicy          = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
        AmazonEKS_CNI_Policy               = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
        AmazonEC2ContainerRegistryReadOnly = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
      }

      tags = {
        "kubernetes.io/cluster/${var.cluster_name}" = "owned"
      }
    }

    ingress_nodes = {
      name           = "ingress-nodes"
      instance_types = ["t3.medium"]
      min_size       = 1
      max_size       = 3
      desired_size   = 1

      # Use public subnets for ingress nodes
      subnet_ids = module.vpc.public_subnets

      labels = {
        role = "ingress"
      }
      iam_role_additional_policies = {
        AmazonEC2FullAccess = "arn:aws:iam::aws:policy/AmazonEC2FullAccess"
      }

      # AMI and capacity settings
      ami_type      = "AL2_x86_64"
      capacity_type = "ON_DEMAND"
    }
  }

  cluster_endpoint_public_access = true
  # cluster_endpoint_public_access_cidrs = ["81.156.163.244/32"]
  cluster_endpoint_private_access = true

  # Add cluster security group rules
  cluster_security_group_additional_rules = {
    egress_nodes_ephemeral_ports_tcp = {
      description                = "To node 1025-65535"
      protocol                   = "tcp"
      from_port                  = 1025
      to_port                    = 65535
      type                       = "egress"
      source_node_security_group = true
    }
  }

  node_security_group_additional_rules = {
    ingress_self_all = {
      description = "Node to node all ports/protocols"
      protocol    = "-1"
      from_port   = 0
      to_port     = 0
      type        = "ingress"
      self        = true
    }
  }
  depends_on = [module.vpc]
}

module "vpc" {
  source       = "./modules/vpc"
  region       = var.region
  cluster_name = var.cluster_name
  vpc_cidr     = var.vpc_cidr
}

module "nginx_ingress" {
  source     = "./modules/nginx"
  depends_on = [module.cert_manager]
}

module "flask_app" {
  source     = "./modules/flask-app"
  depends_on = [module.nginx_ingress]
}

module "cert_manager" {
  source     = "./modules/cert-manager"
  depends_on = [module.eks_cluster]
}

module "monitoring" {
  source = "./modules/monitoring"
  depends_on = [module.eks_cluster]
}

module "aws_auth" {
  source  = "git::https://github.com/terraform-aws-modules/terraform-aws-eks.git//modules/aws-auth?ref=v20.10.0"

  aws_auth_users = [
    {
      userarn  = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:user/${var.iam_user_name}"
      username = var.iam_user_name
      groups   = ["system:masters"]
    },
    {
      userarn  = "arn:aws:iam::447989883825:root"
      username = "root"
      groups   = ["system:masters"]
    }
  ]

  depends_on = [module.eks_cluster]
}

module "argocd" {
  source = "./modules/argocd"
  depends_on = [module.eks_cluster]
}

# resource "kubernetes_config_map" "aws_auth" {
#   metadata {
#     name      = "aws-auth"
#     namespace = "kube-system"
#   }

#   data = {
#     mapRoles = yamlencode([
#       {
#         rolearn  = "arn:aws:iam::<account_id>:role/<nodegroup_role>"
#         username = "system:node:{{EC2PrivateDNSName}}"
#         groups   = ["system:bootstrappers", "system:nodes"]
#       },
#       {
#         rolearn  = "arn:aws:iam::<account_id>:role/<admin_role>"
#         username = "devops-admin"
#         groups   = ["system:masters"]
#       },
#       // Add any pipeline roles here
#     ])
#     # Optionally: mapUsers, mapAccounts
#   }
# }