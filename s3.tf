resource "aws_s3_bucket" "practica7_bucket" {
  bucket = local.s3-sufix
}