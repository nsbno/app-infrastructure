resource "aws_ecr_repository" "ecr_repo" {
  name = var.repo_name
}

resource "aws_ecr_repository_policy" "ecr_policy" {
  repository = aws_ecr_repository.ecr_repo.id
  policy     = data.aws_iam_policy_document.ecr_policy_document.json
}

resource "aws_ecr_lifecycle_policy" "keep_last_N_policy" {
  repository = aws_ecr_repository.ecr_repo.id

  policy = <<EOF
{
    "rules": [
        {
            "rulePriority": 1,
            "description": "Keep last N images",
            "selection": {
                "tagStatus": "tagged",
                "tagPrefixList": ["v"],
                "countType": "imageCountMoreThan",
                "countNumber": ${var.images_to_keep}
            },
            "action": {
                "type": "expire"
            }
        }
    ]
}
EOF
}

data "aws_iam_instance_profile" "current" {
  name = var.instance_profile_name
}

resource "aws_iam_policy" "ecr_access" {
  name        = "${var.instance_profile_name}-ecr-access"
  description = "Provides access to login to ECR, which is a requisite for pulling images"

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "ecr:GetAuthorizationToken",
      "Effect": "Allow",
      "Resource": "*"
    }
  ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "ecr_access_policy_attachment" {
  role       = var.instance_profile_name
  policy_arn = aws_iam_policy.ecr_access.arn
}

data "aws_iam_policy_document" "ecr_policy_document" {
  statement {
    actions = [
      "ecr:BatchCheckLayerAvailability",
      "ecr:BatchGetImage",
      "ecr:GetDownloadUrlForLayer"
    ]

    principals {
      type = "AWS"
      identifiers = [
        data.aws_iam_instance_profile.current.role_arn
      ]
    }
  }
}
