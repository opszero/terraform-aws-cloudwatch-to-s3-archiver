output "s3_bucket_name" {
  description = "The name of the log archive S3 bucket"
  value       = aws_s3_bucket.log_archive.bucket
}

output "s3_bucket_arn" {
  description = "The ARN of the log archive S3 bucket"
  value       = aws_s3_bucket.log_archive.arn
}

output "lambda_function_name" {
  description = "The name of the Lambda function"
  value       = aws_lambda_function.log_archiver.function_name
}

output "lambda_function_arn" {
  description = "The ARN of the Lambda function"
  value       = aws_lambda_function.log_archiver.arn
}

output "iam_role_name" {
  description = "The name of the IAM role assigned to Lambda"
  value       = aws_iam_role.lambda_role.name
}

output "iam_policy_arn" {
  description = "The ARN of the IAM policy for Lambda"
  value       = aws_iam_policy.lambda_policy.arn
}

output "cloudwatch_event_rule_name" {
  description = "The name of the CloudWatch Event Rule"
  value       = aws_cloudwatch_event_rule.schedule.name
}

output "cloudwatch_event_rule_arn" {
  description = "The ARN of the CloudWatch Event Rule"
  value       = aws_cloudwatch_event_rule.schedule.arn
}
