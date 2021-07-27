variable "region" {
  type    = string
  default = "eu-north-1"
}

variable "profile" {
  type    = string
  default = "default"
}

variable "bucket_name" {
  type    = string
  default = "nexus-bucket-from-tf"
}

variable "java_rpm_file_name" {
  type    = string
  default = "jre-8u301-linux-x64.rpm"
}

