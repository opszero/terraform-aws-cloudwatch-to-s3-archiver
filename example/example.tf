provider "aws" {
  region = "us-west-2"
}

module "aws_log_group_to_s3_archiver" {
  source = "./../."

  archive_s3_bucket    = "log-group-to-s3-archiver"
  lambda_function_name = "cloudwatch_log_archiver"
  lambda_runtime       = "python3.13"
  lambda_memory_size   = 256
  lambda_timeout       = 900
  schedule_expression  = "rate(1 day)"
  lambda_role_name     = "log_archiver_role"
  lambda_policy_name   = "log_archiver_policy"
  event_rule_name      = "log_archiver_schedule"
}
