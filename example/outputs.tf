output "s3_bucket_name" {
  description = "The name of the log archive S3 bucket"
  value       = module.aws_log_group_to_s3_archiver.s3_bucket_name
}

output "s3_bucket_arn" {
  description = "The ARN of the log archive S3 bucket"
  value       = module.aws_log_group_to_s3_archiver.s3_bucket_arn
}

output "lambda_function_name" {
  description = "The name of the Lambda function"
  value       = module.aws_log_group_to_s3_archiver.lambda_function_name
}

output "lambda_function_arn" {
  description = "The ARN of the Lambda function"
  value       = module.aws_log_group_to_s3_archiver.lambda_function_arn
}

output "iam_role_name" {
  description = "The name of the IAM role assigned to Lambda"
  value       = module.aws_log_group_to_s3_archiver.iam_role_name
}

output "iam_policy_arn" {
  description = "The ARN of the IAM policy for Lambda"
  value       = module.aws_log_group_to_s3_archiver.iam_policy_arn
}

output "cloudwatch_event_rule_name" {
  description = "The name of the CloudWatch Event Rule"
  value       = module.aws_log_group_to_s3_archiver.cloudwatch_event_rule_name
}

output "cloudwatch_event_rule_arn" {
  description = "The ARN of the CloudWatch Event Rule"
  value       = module.aws_log_group_to_s3_archiver.cloudwatch_event_rule_arn
}
