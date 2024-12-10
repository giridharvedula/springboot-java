# Create a ECR Repository 
resource "aws_ecr_repository" "frontend" {
  name = "sb-repo-frontend"
  image_tag_mutability = "MUTABLE"
  tags = {
    name = "sb-repo-frontend"
  }
}

resource "aws_ecr_repository" "backend" {
  name = "sb-repo-backend"
  image_tag_mutability = "MUTABLE"
  tags = {
    name = "sb-repo-backend"
  }
}
