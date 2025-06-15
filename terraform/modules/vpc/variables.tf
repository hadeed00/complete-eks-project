variable "region" {
  description = "AWS region for the EKS cluster"
  type        = string
}

variable "cluster_name" {
    description = "Name of the EKS cluster"
    type        = string
}

variable "vpc_cidr" {
    description = "CIDR block for the VPC"
    type        = string
}