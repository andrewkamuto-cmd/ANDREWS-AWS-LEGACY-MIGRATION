
# 1. Trust Policy
# Allows EC2 instances to assume this IAM role

data "aws_iam_policy_document" "ec2_assume_role" {
  statement {
    effect = "Allow"

    actions = [
      "sts:AssumeRole"
    ]

    principals {
      type = "Service"

      identifiers = [
        "ec2.amazonaws.com"
      ]
    }
  }
}


# 2. EC2 IAM Role
resource "aws_iam_role" "ec2_role" {
  name = "${var.project_name}-ec2-role"

  assume_role_policy = data.aws_iam_policy_document.ec2_assume_role.json

  tags = {
    Name        = "${var.project_name}-ec2-role"
    Environment = var.environment
    Project     = "andrews-aws-legacy-migration"
  }
}



# SYSTEMS MANAGER
# Allows EC2 to communicate with AWS Systems Manager
# Enables Session Manager and SSM management.

resource "aws_iam_role_policy_attachment" "ssm" {
  role = aws_iam_role.ec2_role.name

  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}



# CLOUDWATCH
# Allows the CloudWatch Agent on EC2 to publish metrics and logs to CloudWatch.

resource "aws_iam_role_policy_attachment" "cloudwatch_agent" {
  role = aws_iam_role.ec2_role.name

  policy_arn = "arn:aws:iam::aws:policy/CloudWatchAgentServerPolicy"
}



# CUSTOM S3 + SECRETS MANAGER POLICY

data "aws_iam_policy_document" "ec2_application_access" {

  statement {
    sid    = "ListMigrationBackupBucket"
    effect = "Allow"

    actions = [
      "s3:ListBucket"
    ]

    resources = [
      aws_s3_bucket.backups.arn
    ]
  }


  # Allow EC2 to read and write migration backup objects

  statement {
    sid    = "AccessMigrationBackupObjects"
    effect = "Allow"

    actions = [
      "s3:GetObject",
      "s3:PutObject"
    ]

    resources = [
      "${aws_s3_bucket.backups.arn}/*"
    ]
  }



  # Allow EC2 to retrieve the database secret

  statement {
    sid    = "ReadDatabaseSecret"
    effect = "Allow"

    actions = [
      "secretsmanager:GetSecretValue",
      "secretsmanager:DescribeSecret"
    ]

    resources = [
      aws_db_instance.mysql.master_user_secret[0].secret_arn
    ]
  }
}


# Custom policy

resource "aws_iam_policy" "ec2_application_access" {
  name        = "${var.project_name}-ec2-application-access"
  description = "Allows EC2 access to migration S3 backups and database secrets"

  policy = data.aws_iam_policy_document.ec2_application_access.json

  tags = {
    Name        = "${var.project_name}-ec2-application-access"
    Environment = var.environment
    Project     = "andrews-aws-legacy-migration"
  }
}


# Attach custom policy to EC2 role

resource "aws_iam_role_policy_attachment" "ec2_application_access" {
  role       = aws_iam_role.ec2_role.name
  policy_arn = aws_iam_policy.ec2_application_access.arn
}


# EC2 INSTANCE PROFILE 
resource "aws_iam_instance_profile" "ec2_profile" {
  name = "${var.project_name}-ec2-profile"

  role = aws_iam_role.ec2_role.name

  tags = {
    Name        = "${var.project_name}-ec2-profile"
    Environment = var.environment
    Project     = "andrews-aws-legacy-migration"
  }
}