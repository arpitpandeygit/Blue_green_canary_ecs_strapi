terraform {
  backend "s3" {
    bucket = "arpit-tf-state-312504613160"
    key    = "strapi/dev/terraform.tfstate"
    region = "us-east-1"
  }
}
