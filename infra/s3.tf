
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

data "local_file" "front_end_files" {
  for_each = fileset("${path.module}/../front_end", "**/*")
  filename = "${path.module}/../front_end/${each.value}"  # Full path to the file
}


output "front_end_files" {
  value = [for file in data.local_file.front_end_files : file.filename]
}

resource "aws_s3_object" "upload_files" {
  for_each = data.local_file.front_end_files
  bucket      = aws_s3_bucket.static_website.id
  key = substr(each.value.filename, 15, length(each.value.filename) - 15)   # remove front_end prefix from all files - modify it later
  source      = "${path.module}/${each.value.filename}"

  content_type = lookup({
    ".html" = "text/html"
    ".js"   = "application/javascript"
    ".css"  = "text/css"
    ".json" = "application/json"
  }, ".${split(".", each.value.filename)[length(split(".", each.value.filename)) - 1]}", "application/octet-stream")

  etag = filebase64sha256("${path.module}/${each.value.filename}")
  depends_on = [aws_s3_bucket.static_website]
}

resource "aws_s3_object" "api_id_object" {
  bucket = aws_s3_bucket.static_website.id
  key    = "api_id.txt"
  content = aws_api_gateway_rest_api.my_api.id 
  etag    = md5(aws_api_gateway_rest_api.my_api.id)
   depends_on = [
    aws_api_gateway_rest_api.my_api,
    local_file.api_id_file
  ]
}