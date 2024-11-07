# CREATE API AND A PATH /submit

resource "aws_api_gateway_rest_api" "my_api" {
  name        = "TerraAPI"
  description = "API created in Terraform"

  endpoint_configuration {
    types = ["REGIONAL"] 
  }
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















# LAMBDA INTEGRATION
resource "aws_api_gateway_integration" "submit_post_integration" {
  rest_api_id             = aws_api_gateway_rest_api.my_api.id
  resource_id             = aws_api_gateway_resource.submit.id
  http_method             = aws_api_gateway_method.submit_post.http_method
  integration_http_method = "POST"
  type                    = "AWS"
  # uri                     = "arn:aws:apigateway:${var.REGION}:lambda:path/2015-03-31/functions/arn:aws:lambda:${var.REGION}:${data.aws_caller_identity.current.account_id}:function:calcTest/invocations"
  uri = "arn:aws:apigateway:${var.REGION}:lambda:path/2015-03-31/functions/arn:aws:lambda:${var.REGION}:${data.aws_caller_identity.current.account_id}:function:lambda_function1/invocations"
 # create a variable later
}



# POST SETUP
resource "aws_api_gateway_method_response" "submit_post_response" {
  rest_api_id = aws_api_gateway_rest_api.my_api.id
  resource_id = aws_api_gateway_resource.submit.id
  http_method = aws_api_gateway_method.submit_post.http_method
  status_code = "200"

  # response_models = {  # tells API to use json format to respond .
  #   "application/json" = "Empty"  # no actual data. it can send just empty json
  # }


  response_parameters = { # headers the API sends back.
    "method.response.header.Access-Control-Allow-Origin" = true # allows domains
  
  }
}



# OPTIONS
resource "aws_api_gateway_method" "submit_options" {
  rest_api_id   = aws_api_gateway_rest_api.my_api.id
  resource_id   = aws_api_gateway_resource.submit.id
  http_method   = "OPTIONS"
  authorization = "NONE"
}

resource "aws_api_gateway_integration" "submit_options_integration" {
  rest_api_id = aws_api_gateway_rest_api.my_api.id
  resource_id = aws_api_gateway_resource.submit.id
  http_method = aws_api_gateway_method.submit_options.http_method
  type        = "MOCK" 

 request_templates = {
    "application/json" = "{ \"statusCode\": 200 }"
  }
}

resource "aws_api_gateway_method_response" "submit_options_response" {
  rest_api_id = aws_api_gateway_rest_api.my_api.id
  resource_id = aws_api_gateway_resource.submit.id
  http_method = aws_api_gateway_method.submit_options.http_method
  status_code = 200


  response_models = {  # tells API to use json format to respond .
    "application/json" = "Empty"  # no actual data. it can send just empty json
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
  
  # response_templates = {
  #   "application/json" = "Empty"
  # }

  response_parameters = {
    "method.response.header.Access-Control-Allow-Origin" = "'*'"  # Allow all origins
    
  }
}





resource "aws_api_gateway_integration_response" "submit_options_integration_response" {
  rest_api_id = aws_api_gateway_rest_api.my_api.id
  resource_id = aws_api_gateway_resource.submit.id
  http_method = aws_api_gateway_method.submit_options.http_method
  status_code = aws_api_gateway_method_response.submit_options_response.status_code

 response_parameters = {
    "method.response.header.Access-Control-Allow-Origin" = "'*'",
    "method.response.header.Access-Control-Allow-Headers" = "'Content-Type,Authorization,X-Amz-Date,X-Api-Key,X-Amz-Security-Token'",
    "method.response.header.Access-Control-Allow-Methods" = "'OPTIONS,POST'"
  }
}




# new lambda
resource "aws_lambda_permission" "allow_api_gateway" {
  statement_id  = "AllowAPIGatewayInvoke"
  action        = "lambda:InvokeFunction"
  function_name = "lambda_function1"    # create a variable 
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${aws_api_gateway_rest_api.my_api.execution_arn}/*/*"
}

# DEPLOYMENT
resource "aws_api_gateway_deployment" "my_api_deployment" {
  rest_api_id = aws_api_gateway_rest_api.my_api.id

  triggers = {
    redeploy = "${timestamp()}"  # Forces a new deployment on every apply
  }
  
  lifecycle { # to properly order deployments. without it can get errors
    create_before_destroy = true
  }

  depends_on = [
    aws_api_gateway_method.submit_post,
    aws_api_gateway_method.submit_options,
    aws_api_gateway_integration.submit_post_integration,
    aws_api_gateway_integration.submit_options_integration,
    aws_api_gateway_method_response.submit_post_response,
    aws_api_gateway_method_response.submit_options_response
  ]

}


resource "aws_api_gateway_stage" "my_stage" {
  deployment_id = aws_api_gateway_deployment.my_api_deployment.id
  rest_api_id   = aws_api_gateway_rest_api.my_api.id
  stage_name    = "test1"
}



output "lambda_function_uri" {
  value       = "arn:aws:apigateway:${var.REGION}:lambda:path/2015-03-31/functions/arn:aws:lambda:${var.REGION}:${data.aws_caller_identity.current.account_id}:function:calcTest/invocations"
  description = "Hello Em, this is URI."
}

resource "local_file" "api_id_file" {
  content  = aws_api_gateway_rest_api.my_api.id
  filename = "${path.module}/api_id.txt"
}

