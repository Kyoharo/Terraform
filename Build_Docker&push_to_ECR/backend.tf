
# Configure the Terraform backend to store state information in S3
terraform {
  backend "s3" {
    bucket = "terraform-state-kyoharo"
    key    = "devops/terraform.tfstate" # Replace with the desired key name for your state file
    region = "us-west-2"
  }
}
