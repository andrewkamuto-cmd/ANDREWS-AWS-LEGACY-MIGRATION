# S3 BACKUP BUCKET

resource "aws_s3_bucket" "backups" {
  bucket_prefix = "andrews-aws-legacy-migration-backups-"

  tags = {
    Name        = "${var.project_name}-backups"
    Environment = var.environment
    Project     = "andrews-aws-legacy-migration"
    Purpose     = "WordPress-Database-Migration-Recovery-Backups"
  }
}


# BLOCK ALL PUBLIC ACCESS

resource "aws_s3_bucket_public_access_block" "backups" {
  bucket = aws_s3_bucket.backups.id

  block_public_acls       = true
  ignore_public_acls      = true
  block_public_policy     = true
  restrict_public_buckets = true
}


# ENABLE VERSIONING

resource "aws_s3_bucket_versioning" "backups" {
  bucket = aws_s3_bucket.backups.id

  versioning_configuration {
    status = "Enabled"
  }
}



# SERVER-SIDE ENCRYPTION

resource "aws_s3_bucket_server_side_encryption_configuration" "backups" {
  bucket = aws_s3_bucket.backups.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}



# BUCKET OWNERSHIP

resource "aws_s3_bucket_ownership_controls" "backups" {
  bucket = aws_s3_bucket.backups.id

  rule {
    object_ownership = "BucketOwnerEnforced"
  }
}




# BACKUP LIFECYCLE MANAGEMENT

resource "aws_s3_bucket_lifecycle_configuration" "backups" {
  bucket = aws_s3_bucket.backups.id

  depends_on = [
    aws_s3_bucket_versioning.backups
  ]

  rule {
    id     = "wordpress-backup-lifecycle"
    status = "Enabled"

    filter {
      prefix = "wordpress/"
    }

    transition {
      days          = 30
      storage_class = "STANDARD_IA"
    }

    transition {
      days          = 90
      storage_class = "GLACIER"
    }
  }

  rule {
    id     = "database-backup-lifecycle"
    status = "Enabled"

    filter {
      prefix = "database/"
    }

    transition {
      days          = 30
      storage_class = "STANDARD_IA"
    }

    transition {
      days          = 90
      storage_class = "GLACIER"
    }
  }

  rule {
    id     = "migration-artifacts-lifecycle"
    status = "Enabled"

    filter {
      prefix = "migration-artifacts/"
    }

    transition {
      days          = 30
      storage_class = "STANDARD_IA"
    }
  }

  rule {
    id     = "recovery-copies-lifecycle"
    status = "Enabled"

    filter {
      prefix = "recovery/"
    }

    transition {
      days          = 30
      storage_class = "STANDARD_IA"
    }

    transition {
      days          = 90
      storage_class = "GLACIER"
    }
  }
}