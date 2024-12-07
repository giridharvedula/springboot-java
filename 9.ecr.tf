# Create a ECR Repository 
resource "aws_ecr_repository" "frontend" {
  name = "sb-java-ecr-repo-frontend"
  image_tag_mutability = "MUTABLE"
  tags = {
    name = "sb-java-ecr-repo-backend"
  }
}

resource "aws_ecr_repository" "backend" {
  name = "sb-java-ecr-repo-backend"
  image_tag_mutability = "MUTABLE"
  tags = {
    name = "sb-java-ecr-repo-backend"
  }
}

