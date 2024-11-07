

resource "aws_s3_bucket" "static_website" {

  bucket = "www.emilija.pro"

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

resource "aws_s3_bucket_cors_configuration" "cors" {
  bucket = aws_s3_bucket.static_website.id

  cors_rule {
    allowed_methods = ["GET", "POST", "PUT"]
    allowed_origins = ["http://www.emilija.pro.s3-website-ap-southeast-2.amazonaws.com", "http://www.emilija.pro"] # change to a variable
    allowed_headers = ["*"]
    expose_headers  = ["ETag"]
  }
}


resource "aws_s3_object" "index_html" {
  bucket = aws_s3_bucket.static_website.id
  key    = "index.html"
  source = "${path.module}/front_end/index.html"
  content_type = "text/html"
  etag          = filemd5("${path.module}/front_end/index.html")
  # depends_on = [aws_s3_bucket_policy.static_website_policy]
}

resource "aws_s3_object" "index_js" {
  bucket = aws_s3_bucket.static_website.id
  key    = "index.js"
  source = "${path.module}/front_end/index.js"
  content_type = "application/javascript"
  etag          = filemd5("${path.module}/front_end/index.js")
  # depends_on = [aws_s3_bucket_policy.static_website_policy]
}


resource "aws_s3_object" "api_id_object" {
  bucket = "www.emilija.pro" # change to a variable later
  key    = "api_id.txt"
  content = aws_api_gateway_rest_api.my_api.id 
  etag    = md5(aws_api_gateway_rest_api.my_api.id)
   depends_on = [
    aws_api_gateway_rest_api.my_api,
    local_file.api_id_file
  ]
}

resource "aws_s3_object" "test_html" {
  bucket = aws_s3_bucket.static_website.id
  key    = "test.html"
  source = "${path.module}/front_end/test.html" # Update the path as needed
  content_type = "text/html"
  etag          = filemd5("${path.module}/front_end/test.html")
}