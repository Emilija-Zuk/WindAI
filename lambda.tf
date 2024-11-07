

data "archive_file" "lambda1" {
  type        = "zip"
  source_dir  = "${path.module}/python/"
#   source_file = "${path.module}/python/lambda1.py"  
  output_path = "${path.module}/python/lambda1.zip"
}


data "aws_iam_policy_document" "assume_role" {
  statement {
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["lambda.amazonaws.com"]
    }

    actions = ["sts:AssumeRole"]
  }
}

resource "aws_iam_role" "iam_for_lambda" {
  name               = "iam_for_lambda"
  assume_role_policy = data.aws_iam_policy_document.assume_role.json
}


resource "aws_lambda_function" "test_lambda" {

  filename      = "${path.module}/python/lambda1.zip"
  function_name = "lambda_function1"
  role          = aws_iam_role.iam_for_lambda.arn
  
  handler       = "index.lambda_handler" # lambda_handler is specified in index.py. function entry

  source_code_hash = data.archive_file.lambda1.output_base64sha256

  runtime         = "python3.12"

  environment {
    variables = {
      foo = "bar"
    }
  }
} 










# I can upload zip file to s3 bucket but i can use a local zip file
# resource "aws_s3_object" "lambda1" {
#   bucket = aws_s3_bucket.lambda_bucket.id # change this.
#   key    = "lambda1.zip"  # that is created
#   source = data.archive_file.lambda1.output_path
#   etag = filemd5(data.archive_file.lambda1.output_path)
# }



