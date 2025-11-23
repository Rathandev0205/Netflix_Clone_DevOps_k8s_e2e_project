resource "aws_iam_role" "ec2_ssm_role" {
  name = "${local.org}-${local.project}-${var.env}-ec2-ssm-role"

  # Terraform's "jsonencode" function converts a
  # Terraform expression result to valid JSON syntax.
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Sid    = ""
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      },
    ]
  })

  tags = {
    Name        = "${local.org}-${local.project}-${var.env}-ec2-ssm-role"
    environment = var.env
  }
}

resource "aws_iam_role_policy_attachment" "ec2_ssm_role_attachment" {
  role       = aws_iam_role.ec2_ssm_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

resource "aws_iam_instance_profile" "ec2_ssm_profile" {
  name = "${local.org}-${local.project}-${var.env}-ec2-ssm-profile"
  role = aws_iam_role.ec2_ssm_role.name
}