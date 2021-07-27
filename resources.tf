resource "aws_s3_bucket" "nexus_bucket" {
  # create bucket
  bucket = var.bucket_name
  acl    = "private"

  versioning {
    enabled = true
  }

  tags = {
    Name        = "Nexus bucket"
    Environment = "Test"
  }
}

resource "aws_s3_bucket_public_access_block" "nexus_bucket_permissions" {
  # block public access to the bucket
  bucket = aws_s3_bucket.nexus_bucket.id

  block_public_acls       = true
  block_public_policy     = true
  restrict_public_buckets = true
  ignore_public_acls      = true
}

resource "aws_s3_bucket_policy" "nexus_bucket_policy" {
  # create new policy for bucket
  bucket = aws_s3_bucket.nexus_bucket.id

  policy = data.aws_iam_policy_document.nexus_get_objects_limited_access.json

  depends_on = [
    aws_s3_bucket.nexus_bucket,
    aws_s3_bucket_public_access_block.nexus_bucket_permissions
  ]
}

resource "aws_s3_bucket_object" "java_rpm" {
  # upload file to the bucket
  bucket = aws_s3_bucket.nexus_bucket.id
  source = var.java_rpm_file_name
  key    = var.java_rpm_file_name

  depends_on = [
    aws_s3_bucket.nexus_bucket
  ]
}