resource "aws_s3_bucket" "backup_bucket" {
  bucket   = var.backup_bucket_name
  provider = aws.backup
  acl      = "private"

  versioning {
    enabled = true
  }

  tags = {
    Name        = "Nexus backup bucket"
    Environment = "Test"
  }
}

resource "aws_s3_bucket_public_access_block" "backup_bucket_permissions" {
  # block public access to the bucket
  bucket   = aws_s3_bucket.backup_bucket.id
  provider = aws.backup

  block_public_acls       = true
  block_public_policy     = true
  restrict_public_buckets = true
  ignore_public_acls      = true
}