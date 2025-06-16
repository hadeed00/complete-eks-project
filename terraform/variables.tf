variable "region" {
  default = "eu-west-2"
}

variable "cluster_name" {
  default = "flask-eks-project"
}

variable "vpc_cidr" {
  default = "10.0.0.0/16"
}

variable "iam_user_name" {
  description = "The IAM user name to grant EKS admin access."
  type        = string
  default     = "devops-admin"
}