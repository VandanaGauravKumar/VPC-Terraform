resource "aws_s3_bucket" "s3-for-statefile" {
  bucket = "my-tf-bucket-statefile"

  tags = {
    Name = "${var.env}-s3-statefile"
        Environment = var.env
  }
}

/*resource "aws_s3_bucket_acl" "s3-acl" {
  bucket = aws_s3_bucket.s3-for-statefile.id
  acl    = "private"
}*/

resource "aws_s3_bucket_versioning" "s3-versioning" {
  bucket = aws_s3_bucket.s3-for-statefile.id
  versioning_configuration {
    status = "Enabled"
  }
}