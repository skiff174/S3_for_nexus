variable "region" {
  type    = string
  default = "eu-north-1"
}

variable "backup_region" {
  type    = string
  default = "eu-central-1"
}

variable "profile" {
  type    = string
  default = "default"
}

variable "nexus_bucket_name" {
  type    = string
  default = "nexus-bucket-from-tf"
}

variable "backup_bucket_name" {
  type    = string
  default = "backup-bucket-from-tf"
}

variable "java_rpm_file_name" {
  type    = string
  default = "jre-8u301-linux-x64.rpm"
}

