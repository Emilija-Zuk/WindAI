


resource "aws_api_gateway_rest_api" "my_api" {
  name        = "TerAPI"
  description = "API created in Terraform"
}

resource "aws_api_gateway_resource" "submit" {
  rest_api_id = aws_api_gateway_rest_api.my_api.id
  parent_id   = aws_api_gateway_rest_api.my_api.root_resource_id
  path_part   = "submit"
}

resource "aws_api_gateway_method" "submit_post" {
  rest_api_id   = aws_api_gateway_rest_api.my_api.id
  resource_id   = aws_api_gateway_resource.submit.id
  http_method   = "POST"
  authorization = "NONE"
}

resource "aws_api_gateway_integration" "lambda_integration" {
  rest_api_id             = aws_api_gateway_rest_api.my_api.id
  resource_id             = aws_api_gateway_resource.submit.id
  http_method             = aws_api_gateway_method.submit_post.http_method
  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = "arn:aws:lambda:${var.REGION}:${data.aws_caller_identity.current.account_id}:function:calcTest"
}


resource "aws_api_gateway_method_response" "submit_post_response" {
  rest_api_id = aws_api_gateway_rest_api.my_api.id
  resource_id = aws_api_gateway_resource.submit.id
  http_method = aws_api_gateway_method.submit_post.http_method
  status_code = "200"

  response_models = {
    "application/json" = "Empty"
  }

  
  response_parameters = {
    "method.response.header.Access-Control-Allow-Origin" = true,
    "method.response.header.Access-Control-Allow-Headers" = true,
    "method.response.header.Access-Control-Allow-Methods" = true
  }
  
}

resource "aws_api_gateway_integration_response" "lambda_integration_response" {
  rest_api_id = aws_api_gateway_rest_api.my_api.id
  resource_id = aws_api_gateway_resource.submit.id
  http_method = aws_api_gateway_method.submit_post.http_method
  status_code = aws_api_gateway_method_response.submit_post_response.status_code

  response_parameters = {
    "method.response.header.Access-Control-Allow-Origin" = true,
    "method.response.header.Access-Control-Allow-Headers" = true,
    "method.response.header.Access-Control-Allow-Methods" = true
  }
}

resource "aws_api_gateway_deployment" "my_api_deployment" {
  rest_api_id = aws_api_gateway_rest_api.my_api.id
  stage_name  = "test"
}

resource "aws_api_gateway_method" "submit_options" {
  rest_api_id   = aws_api_gateway_rest_api.my_api.id
  resource_id   = aws_api_gateway_resource.submit.id
  http_method   = "OPTIONS"
  authorization = "NONE"
}

resource "aws_api_gateway_integration" "options_integration" {
  rest_api_id             = aws_api_gateway_rest_api.my_api.id
  resource_id             = aws_api_gateway_resource.submit.id
  http_method             = aws_api_gateway_method.submit_options.http_method
  
  type                    = "MOCK"

  request_templates = {
    "application/json" = "{\"statusCode\": 200}"
  }
}

resource "aws_api_gateway_method_response" "submit_options_response" {
  rest_api_id = aws_api_gateway_rest_api.my_api.id
  resource_id = aws_api_gateway_resource.submit.id
  http_method = aws_api_gateway_method.submit_options.http_method
  status_code = "200"

  response_models = {
    "application/json" = "Empty"
  }

  response_parameters = {
    "method.response.header.Access-Control-Allow-Headers" = true, 
    "method.response.header.Access-Control-Allow-Methods" = true,
    "method.response.header.Access-Control-Allow-Origin"  = true
  }
}
