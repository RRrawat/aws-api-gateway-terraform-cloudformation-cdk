#---------------------------------------------------
# AWS API Gateway api key
#---------------------------------------------------
resource "aws_api_gateway_api_key" "api_gateway_api_key" {
  count = var.enable_api_gateway_api_key ? 1 : 0

  name        = var.api_gateway_api_key_name
  description = var.api_gateway_api_key_description
  enabled     = var.api_gateway_api_key_enabled
  value       = var.api_gateway_api_key_value

  tags = {
    env = "dev"
  }

  lifecycle {
    create_before_destroy = true
    ignore_changes        = []
  }

  depends_on = [aws_api_gateway_rest_api.api_gateway_rest_api]
}

#---------------------------------------------------
# AWS API Gateway usage plan
#---------------------------------------------------
resource "aws_api_gateway_usage_plan" "api_gateway_usage_plan" {
  count        = var.enable_api_gateway_usage_plan ? 1 : 0
  name         = var.api_gateway_usage_plan_name
  description  = var.api_gateway_usage_plan_description
  product_code = var.api_gateway_usage_plan_product_code

  api_stages {
    api_id = element(concat(aws_api_gateway_rest_api.api_gateway_rest_api.*.id, [""]), 0)
    stage  = element(concat(aws_api_gateway_stage.api_gateway_stage_dev.*.stage_name, [""]), 0)
  }
  #we can use multiple api_stages for the multiple env 

  quota_settings {
    limit  = 2000
    offset = 0
    period = "DAY"
  }

  throttle_settings {
    burst_limit = 1000
    rate_limit  = 100
  }
  lifecycle {
    create_before_destroy = true
    ignore_changes        = []
  }
}


#---------------------------------------------------
# AWS API Gateway usage plan key
#---------------------------------------------------
resource "aws_api_gateway_usage_plan_key" "api_gateway_usage_plan_key" {
  count = var.enable_api_gateway_usage_plan_key ? 1 : 0

  key_id        = element(concat(aws_api_gateway_api_key.api_gateway_api_key.*.id, [""]), 0)
  key_type      = upper(var.api_gateway_usage_plan_key_key_type)
  usage_plan_id = element(concat(aws_api_gateway_usage_plan.api_gateway_usage_plan.*.id, [""]), 0)

  lifecycle {
    create_before_destroy = true
    ignore_changes        = []
  }

  depends_on = [
    aws_api_gateway_api_key.api_gateway_api_key,
    aws_api_gateway_usage_plan.api_gateway_usage_plan
  ]
}
