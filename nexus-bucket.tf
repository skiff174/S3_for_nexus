resource "aws_s3_bucket" "nexus_bucket" {
  # create bucket
  bucket = var.nexus_bucket_name
  acl    = "private"

  versioning {
    enabled = true
  }

  lifecycle {
    prevent_destroy = true
  }

  replication_configuration {
    role = aws_iam_role.replication_role.arn

    rules {
      id     = "Bucket replication"
      status = "Enabled"

      destination {
        bucket        = aws_s3_bucket.backup_bucket.arn
        storage_class = "STANDARD"
      }
    }
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

  policy = <<POLICY
{
  "Version":"2012-10-17",
  "Statement":[
    {
      "Sid":"NexusS3LimitedRead",
      "Effect":"Allow",
      "Principal": {"AWS": ["arn:aws:iam::177060502583:user/Ivan"]},
      "Action":["s3:GetObject"],
      "Resource":"arn:aws:s3:::${var.nexus_bucket_name}/*"
    }
  ]
}
POLICY

  depends_on = [
    aws_s3_bucket.nexus_bucket,
    aws_s3_bucket_public_access_block.nexus_bucket_permissions
  ]
}

resource "aws_iam_role" "replication_role" {
  name = "nexus-bucket-replication-role"

  assume_role_policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "s3.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
POLICY
}

resource "aws_iam_policy" "replication_policy" {
  name = "nexus-bucket-replication-policy"

  policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
        "Effect":"Allow",
        "Action":[
          "s3:GetReplicationConfiguration",
          "s3:ListBucket"
        ],
        "Resource":[
          "${aws_s3_bucket.nexus_bucket.arn}"
        ]
    },
    {
        "Effect":"Allow",
        "Action":[
          "s3:GetObjectVersionForReplication",
          "s3:GetObjectVersionAcl",
          "s3:GetObjectVersionTagging"
        ],
        "Resource":[
          "${aws_s3_bucket.nexus_bucket.arn}/*"
        ]
    },
    {
      "Action": [
        "s3:ReplicateObject",
        "s3:ReplicateDelete",
        "s3:ReplicateTags"
      ],
      "Effect": "Allow",
      "Resource": "${aws_s3_bucket.backup_bucket.arn}/*"
    }
  ]
}
POLICY
}

resource "aws_iam_role_policy_attachment" "replication" {
  role       = aws_iam_role.replication_role.name
  policy_arn = aws_iam_policy.replication_policy.arn
}


# resource "aws_s3_bucket_object" "java_rpm" {
#   # upload file to the bucket
#   bucket = aws_s3_bucket.nexus_bucket.id
#   source = var.java_rpm_file_name
#   key    = "packages/${var.java_rpm_file_name}"

#   depends_on = [
#     aws_s3_bucket.nexus_bucket,
#     aws_s3_bucket.backup_bucket
#   ]
# }