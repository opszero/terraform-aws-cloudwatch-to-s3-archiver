variable "enabled" {
  description = "Globally enable or disable the entire module"
  type        = bool
  default     = true
}

variable "enable_s3" {
  description = "Enable or disable S3 bucket creation"
  type        = bool
  default     = true
}

variable "enable_lambda" {
  description = "Enable or disable Lambda function creation"
  type        = bool
  default     = true
}

variable "enable_event_rule" {
  description = "Enable or disable CloudWatch Event Rule for Lambda"
  type        = bool
  default     = true
}

variable "archive_s3_bucket" {
  description = "S3 bucket name for archiving CloudWatch logs"
  type        = string
  default     = "log-group-to-s3-archiver"
}

variable "lambda_function_name" {
  description = "Name of the Lambda function"
  type        = string
  default     = "cloudwatch_log_archiver"
}

variable "lambda_runtime" {
  description = "Runtime for the Lambda function"
  type        = string
  default     = "python3.13"
}

variable "lambda_memory_size" {
  description = "Memory size for Lambda function"
  type        = number
  default     = 256
}

variable "lambda_timeout" {
  description = "Timeout for Lambda function"
  type        = number
  default     = 900
}

variable "schedule_expression" {
  description = "Schedule expression for CloudWatch event rule"
  type        = string
  default     = "rate(1 day)"
}

variable "lambda_role_name" {
  description = "IAM Role name for Lambda function"
  type        = string
  default     = "log_archiver_role"
}

variable "lambda_policy_name" {
  description = "IAM Policy name for Lambda function"
  type        = string
  default     = "log_archiver_policy"
}

variable "event_rule_name" {
  description = "Name of the CloudWatch event rule"
  type        = string
  default     = "log_archiver_schedule"
}
