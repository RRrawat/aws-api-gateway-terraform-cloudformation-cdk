############################################
#Terraform State File Backend Configuration:
##########################################

terraform {
  backend "s3" {
    bucket = "practice-bucket030722"
    key    = "api-gateway/terraform.tfstate"
    region = "ap-south-1"
  }
}
