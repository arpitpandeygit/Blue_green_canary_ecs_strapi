terraform {
  backend "s3" {
    bucket         = "pp-tf-state-312504613160"
    key            = "strapi/dev/terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "terraform-locks"
    encrypt        = true
  }
}