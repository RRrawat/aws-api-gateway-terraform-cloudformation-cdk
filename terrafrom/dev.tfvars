region = "ap-south-1"


# AWS API Gateway rest api

enable_api_gateway_rest_api      = true
api_gateway_rest_api_name        = "nfl-api-gateway"
api_gateway_rest_api_description = "api gateway description"
endpoint_type                    = "REGIONAL"


# AWS API Gateway api key
enable_api_gateway_api_key  = true
api_gateway_api_key_name    = "dev-key"
api_gateway_api_key_enabled = true


# AWS API Gateway deployment

enable_api_gateway_deployment            = true
api_gateway_deployment_description       = null
api_gateway_deployment_stage_name        = "dev2"
api_gateway_deployment_stage_description = "dev_env"
api_gateway_deployment_variables         = null

# AWS API Gateway stage
enable_api_gateway_stage      = true
api_gateway_stage_stage_name  = "dev"
api_gateway_stage_description = null

# AWS API Gateway usage plan
enable_api_gateway_usage_plan      = true
api_gateway_usage_plan_name        = "dev_usage_plan"
api_gateway_usage_plan_description = "usage_description"


#---------------------------------------------------
# AWS API Gateway resource
enable_api_gateway_resource    = true
api_gateway_resource_path_part = "nfl-proxy"

# AWS API Gateway method
enable_api_gateway_method           = true
api_gateway_method_http_method      = "POST"
api_gateway_method_api_key_required = true

# AWS API Gateway integration
enable_api_gateway_integration                  = true
api_gateway_integration_type                    = "AWS"
api_gateway_integration_integration_http_method = "POST"
api_gateway_integration_uri                     = "arn:aws:apigateway:ap-south-1:lambda:path/2015-03-31/functions/arn:aws:lambda:ap-south-1:306406016812:function:getAccessToken/invocations"

# AWS API Gateway method response
api_gateway_method_response_status_code        = 200
enable_api_gateway_method_response             = true


# AWS API Gateway integration response
enable_api_gateway_integration_response = true
