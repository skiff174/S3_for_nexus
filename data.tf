/*data "aws_iam_policy_document" "nexus_get_objects_to_all" {
  #this policy allows get object access to all users
  statement {
    sid = "NexusS3PublicRead"
    actions   = ["s3:GetObject"]
    resources = ["arn:aws:s3:::${var.bucket_name}/*"]
    effect = "Allow"
    principals {
      type = "*"
      identifiers = ["*"]
    } 
  }
}*/

data "aws_iam_policy_document" "nexus_get_objects_limited_access" {
  #this policy allows get object access to limited users
  statement {
    sid       = "NexusS3LimitedRead"
    actions   = ["s3:GetObject"]
    resources = ["arn:aws:s3:::${var.bucket_name}/*"]
    effect    = "Allow"
    principals {
      type        = "AWS"
      identifiers = ["arn:aws:iam::177060502583:user/Ivan"]
    }
  }
}
