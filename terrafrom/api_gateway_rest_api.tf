#---------------------------------------------------
# AWS API Gateway rest api
#---------------------------------------------------
resource "aws_api_gateway_rest_api" "api_gateway_rest_api" {
  count = var.enable_api_gateway_rest_api ? 1 : 0

  name        = var.api_gateway_rest_api_name
  description = var.api_gateway_rest_api_description
  #body = var.api_gateway_rest_api_body
  tags = {
    env = "dev"
  }

  endpoint_configuration {
    types = [var.endpoint_type]
  }


  lifecycle {
    create_before_destroy = true
    ignore_changes        = []
  }

  depends_on = []
}

#---------------------------------------------------
# AWS API Gateway resource
#---------------------------------------------------
resource "aws_api_gateway_resource" "api_gateway_resource" {
  count = var.enable_api_gateway_resource ? 1 : 0

  rest_api_id = aws_api_gateway_rest_api.api_gateway_rest_api[0].id
  parent_id   = element(concat(aws_api_gateway_rest_api.api_gateway_rest_api.*.root_resource_id, [""]), 0)
  path_part   = var.api_gateway_resource_path_part

  lifecycle {
    create_before_destroy = true
    ignore_changes        = []
  }

  depends_on = [
    aws_api_gateway_rest_api.api_gateway_rest_api
  ]
}

#---------------------------------------------------
# AWS API Gateway method
#---------------------------------------------------

resource "aws_api_gateway_method" "api_gateway_method" {
  count = var.enable_api_gateway_method ? 1 : 0

  authorization    = "NONE"
  http_method      = upper(var.api_gateway_method_http_method)
  resource_id      = aws_api_gateway_resource.api_gateway_resource[0].id
  rest_api_id      = aws_api_gateway_rest_api.api_gateway_rest_api[0].id
  api_key_required = var.api_gateway_method_api_key_required
}
#---------------------------------------------------
# AWS API Gateway deployment
#---------------------------------------------------
resource "aws_api_gateway_deployment" "api_gateway_deployment" {
  count       = var.enable_api_gateway_deployment ? 1 : 0
  rest_api_id = aws_api_gateway_rest_api.api_gateway_rest_api[0].id
  triggers = {
    redeployment = sha1(jsonencode(aws_api_gateway_rest_api.api_gateway_rest_api[0].body))
  }

  lifecycle {
    create_before_destroy = true
    ignore_changes        = []
  }

  depends_on = [
    aws_api_gateway_rest_api.api_gateway_rest_api, aws_api_gateway_method.api_gateway_method
  ]
}

#---------------------------------------------------
# AWS API Gateway stage
#---------------------------------------------------
resource "aws_api_gateway_stage" "api_gateway_stage_dev" {
  count = var.enable_api_gateway_stage ? 1 : 0

  rest_api_id   = aws_api_gateway_rest_api.api_gateway_rest_api[0].id
  deployment_id = aws_api_gateway_deployment.api_gateway_deployment[0].id
  stage_name    = var.api_gateway_stage_stage_name
  description   = var.api_gateway_stage_description

  lifecycle {
    create_before_destroy = true
    ignore_changes        = []
  }
}
#---------------------------------------------------
# AWS API Gateway integration
#---------------------------------------------------
resource "aws_api_gateway_integration" "api_gateway_integration" {
  count = var.enable_api_gateway_integration ? 1 : 0

  rest_api_id             = element(concat(aws_api_gateway_rest_api.api_gateway_rest_api.*.id, [""]), 0)
  resource_id             = element(concat(aws_api_gateway_resource.api_gateway_resource.*.id, [""]), 0)
  http_method             = element(concat(aws_api_gateway_method.api_gateway_method.*.http_method, [""]), 0)
  type                    = upper(var.api_gateway_integration_type)
  integration_http_method = var.api_gateway_integration_integration_http_method
  uri                     = var.api_gateway_integration_uri

  lifecycle {
    create_before_destroy = true
    ignore_changes        = []
  }

  depends_on = [
    aws_api_gateway_rest_api.api_gateway_rest_api,
    aws_api_gateway_resource.api_gateway_resource,
    aws_api_gateway_method.api_gateway_method
  ]
}
#---------------------------------------------------
# AWS API Gateway method response
#---------------------------------------------------
resource "aws_api_gateway_method_response" "api_gateway_method_response" {
  count = var.enable_api_gateway_method_response ? 1 : 0

  rest_api_id = element(concat(aws_api_gateway_rest_api.api_gateway_rest_api.*.id, [""]), 0)
  resource_id = element(concat(aws_api_gateway_resource.api_gateway_resource.*.id, [""]), 0)
  http_method = element(concat(aws_api_gateway_method.api_gateway_method.*.http_method, [""]), 0)
  status_code = var.api_gateway_method_response_status_code

  response_models    = var.api_gateway_method_response_response_models
  
  lifecycle {
    create_before_destroy = true
    ignore_changes        = []
  }

  depends_on = [
    aws_api_gateway_rest_api.api_gateway_rest_api,
    aws_api_gateway_resource.api_gateway_resource,
    aws_api_gateway_method.api_gateway_method
  ]
}
#---------------------------------------------------
# AWS API Gateway integration response
#---------------------------------------------------
resource "aws_api_gateway_integration_response" "api_gateway_integration_response" {
  count = var.enable_api_gateway_integration_response ? 1 : 0

  rest_api_id = element(concat(aws_api_gateway_rest_api.api_gateway_rest_api.*.id, [""]), 0)
  resource_id = element(concat(aws_api_gateway_resource.api_gateway_resource.*.id, [""]), 0)
  http_method = element(concat(aws_api_gateway_method.api_gateway_method.*.http_method, [""]), 0)
  status_code = element(concat(aws_api_gateway_method_response.api_gateway_method_response.*.status_code, [""]), 0)
  response_templates = var.api_gateway_method_response_response_templates

  lifecycle {
    create_before_destroy = true
    ignore_changes        = []
  }

  depends_on = [
    aws_api_gateway_rest_api.api_gateway_rest_api,
    aws_api_gateway_resource.api_gateway_resource,
    aws_api_gateway_method.api_gateway_method,
    aws_api_gateway_method_response.api_gateway_method_response
  ]
}
