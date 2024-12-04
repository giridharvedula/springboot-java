terraform {
  backend "s3" {
    bucket         = "terraform-state-springboot" # change this to your bucket name 
    key            = "terraform.tfstate" # path of the folder in bucket
    region         = "us-east-1"
    encrypt        = true
    dynamodb_table = "terraform-state-springboot"
  }
}
