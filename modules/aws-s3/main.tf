data "aws_caller_identity" "current" {}

resource "aws_s3_bucket" "bucket" {
  bucket        = "isg-esatp-dv-${var.name}-${data.aws_caller_identity.current.account_id}"
  force_destroy = false
}

resource "aws_s3_bucket_server_side_encryption_configuration" "sse" {
  bucket = aws_s3_bucket.bucket.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}
