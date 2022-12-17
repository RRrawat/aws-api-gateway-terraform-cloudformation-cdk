############################################
#Terraform State File Backend Configuration:
##########################################

terraform {
  backend "s3" {
    bucket = "<Bucket Name>"
    key    = "<S3 bucket_key>/terraform.tfstate"
    region = "ap-south-1"
  }
}
