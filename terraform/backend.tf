terraform {
  backend "s3" {
    bucket = "flask-eks-terraform-state"
    key    = "eks-project/terraform.tfstate"
    region = "eu-west-2"
  }
}
