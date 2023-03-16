module "lambda_function_in_vpc" {
  source  = "terraform-aws-modules/lambda/aws"
  version = "~> 4.12"

  function_name = "${local.name}-go"
  description   = "Lambda function with OTEL instrumentation"
  handler       = "main.lambda_handler"
  runtime       = "go1.x"
  timeout       = 60

  source_path = "lambda/"

  vpc_subnet_ids         = module.vpc.private_subnets
  vpc_security_group_ids = [aws_security_group.lambda.id]
  attach_network_policy  = true

  create_role = true

  attach_policy_statements = true
  policy_statements        = {}

  environment_variables = {
    OPENTELEMETRY_COLLECTOR_CONFIG_FILE = "/var/task/lambda/otelcol-config.yml"
  }

}

resource "aws_security_group" "lambda" {
  name        = "${local.name}-lambda"
  description = "SG for the Lambda function"
  vpc_id      = module.vpc.vpc_id

  tags = local.tags
}
