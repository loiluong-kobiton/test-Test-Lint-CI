provider "aws" {
    region = "ap-southeast-2"
    access_key = "AKIATLSF73HKN25FQGFU"
    secret_key = "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"
  
}

resource "aws_s3_bucket_" "terraform-bucket" {
  bucket = "terraform-bucket-testing"
  acl = "public-read"
  policy = file("s3_policy_test.json")

  website {
    index_document = "index.html"
    error_document = "error.html"
  }
  tags = {
    Name        = "Terraform-s3-testing"
  }
}


locals {
  mime_types = {
    html  = "text/html"
    css   = "text/css"
    ttf   = "font/ttf"
    woff  = "font/woff"
    woff2 = "font/woff2"
    js    = "application/javascript"
    map   = "application/javascript"
    json  = "application/json"
    jpg   = "image/jpeg"
    png   = "image/png"
    svg   = "image/svg+xml"
    eot   = "application/vnd.ms-fontobject"
  }
}

resource "aws_s3_bucket_object" "object" {
  for_each = fileset(path.module, "static-web/**/*")
  bucket = aws_s3_bucket.terraform-bucket.id
  key = replace(each.value, "static-web", "")
  source = each.value
  etag = filemd5("${each.value}")
  content_type = lookup(local.mime_types, split(".", each.value)[length(split(".", each.value)) - 1])
  
}


