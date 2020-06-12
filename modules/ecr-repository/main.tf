resource "aws_ecr_repository" "ecr_repo" {
  name = var.repo_name
}

resource "aws_ecr_lifecycle_policy" "keep_last_N_policy" {
  repository = aws_ecr_repository.ecr_repo.id

  policy = <<EOF
{
    "rules": [
        {
            "rulePriority": 1,
            "description": "Keep last N release images",
            "selection": {
                "tagStatus": "tagged",
                "tagPrefixList": ["commit-"],
                "countType": "imageCountMoreThan",
                "countNumber": ${var.images_to_keep}
            },
            "action": {
                "type": "expire"
            }
        },
        {
            "rulePriority": 2,
            "description": "Keep builder image",
            "selection": {
                "tagStatus": "tagged",
                "tagPrefixList": ["builder"],
                "countType": "imageCountMoreThan",
                "countNumber": 1
            },
            "action": {
                "type": "expire"
            }
        },
        {
            "rulePriority": 3,
            "description": "Remove other images",
            "selection": {
                "tagStatus": "any",
                "countType": "sinceImagePushed",
                "countUnit": "days",
                "countNumber": 7
            },
            "action": {
                "type": "expire"
            }
        }
    ]
}
EOF
}
