

resource "aws_s3_bucket" "static_website" {

  bucket = "estimator2"

  tags = {
    Name        = "My test bucket"
    Environment = "Dev"
  }
}

resource "aws_s3_bucket_public_access_block" "unblock" {
  bucket = aws_s3_bucket.static_website.id

  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false

}



resource "aws_s3_bucket_website_configuration" "website" {

  bucket = aws_s3_bucket.static_website.id

  index_document {
    suffix = "index.html"
  }

}


resource "aws_s3_bucket_policy" "static_website_policy" {
  bucket = aws_s3_bucket.static_website.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid = "PublicReadGetObject"
        Effect = "Allow"
        Principal = "*"
        Action = "s3:GetObject"
        Resource = "${aws_s3_bucket.static_website.arn}/*"
      }
    ]
  })

  depends_on = [
    aws_s3_bucket.static_website,
    aws_s3_bucket_public_access_block.unblock
  ]
}




resource "aws_s3_object" "index_html" {
  bucket = aws_s3_bucket.static_website.id
  key    = "index.html"
  source = "${path.module}/index.html"
  content_type = "text/html"
  etag          = filemd5("${path.module}/index.html")
  # depends_on = [aws_s3_bucket_policy.static_website_policy]
}

resource "aws_s3_object" "index_js" {
  bucket = aws_s3_bucket.static_website.id
  key    = "index.js"
  source = "${path.module}/index.js"
  content_type = "application/javascript"
  etag          = filemd5("${path.module}/index.js")
  # depends_on = [aws_s3_bucket_policy.static_website_policy]
}
