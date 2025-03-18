variable "archive_s3_bucket" {
  description = "S3 bucket name for archiving CloudWatch logs"
  type        = string
  default     = "log-group-to-s3-archiver"
}

# S3 Bucket for Log Archive
resource "aws_s3_bucket" "log_archive" {
  bucket = var.archive_s3_bucket
}

# IAM Role for Lambda
resource "aws_iam_role" "lambda_role" {
  name = var.archive_s3_bucket

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Action = "sts:AssumeRole"
      Effect = "Allow"
      Principal = {
        Service = "lambda.amazonaws.com"
      }
    }]
  })
}

# IAM Policy for Lambda
resource "aws_iam_policy" "lambda_policy" {
  name        = var.archive_s3_bucket
  description = "Permissions for the Lambda function to archive CloudWatch logs"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "logs:DescribeLogGroups",
          "logs:CreateExportTask",
          "logs:DescribeExportTasks",
          "logs:DeleteLogGroup"
        ]
        Resource = "*"
      },
      {
        Effect = "Allow"
        Action = [
          "s3:PutObject",
          "s3:PutObjectAcl"
        ]
        Resource = "${aws_s3_bucket.log_archive.arn}/*"
      },
      {
        Effect = "Allow"
        Action = [
          "logs:CreateLogStream",
          "logs:PutLogEvents"
        ]
        Resource = "arn:aws:logs:*:*:log-group:/aws/lambda/*"
      }
    ]
  })
}

# Attach IAM Policy to Role
resource "aws_iam_role_policy_attachment" "lambda_attach" {
  role       = aws_iam_role.lambda_role.name
  policy_arn = aws_iam_policy.lambda_policy.arn
}

data "archive_file" "function" {
  type        = "zip"
  source_file = "lambda/main.py"
  output_path = "lambda_function.zip"
}

# Lambda Function
resource "aws_lambda_function" "log_archiver" {
  function_name = "cloudwatch_log_archiver"
  role          = aws_iam_role.lambda_role.arn
  runtime       = "python3.13"
  handler       = "lambda_function.lambda_handler"
  timeout       = 900 # 15 min timeout for large exports
  memory_size   = 256

  filename         = data.archive_file.function.output_path
  source_code_hash = data.archive_file.function.output_base64sha256

  environment {
    variables = {
      S3_BUCKET = aws_s3_bucket.log_archive.bucket
    }
  }
}

# CloudWatch Event Rule to Trigger Lambda Periodically
resource "aws_cloudwatch_event_rule" "schedule" {
  name                = "log_archiver_schedule"
  description         = "Triggers log archiving every day"
  schedule_expression = "rate(1 day)"
}

# Event Rule Target (Lambda)
resource "aws_cloudwatch_event_target" "trigger_lambda" {
  rule      = aws_cloudwatch_event_rule.schedule.name
  target_id = "log_archiver_lambda"
  arn       = aws_lambda_function.log_archiver.arn
}

# Lambda Permission for CloudWatch
resource "aws_lambda_permission" "allow_cloudwatch" {
  statement_id  = "AllowExecutionFromCloudWatch"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.log_archiver.function_name
  principal     = "events.amazonaws.com"
  source_arn    = aws_cloudwatch_event_rule.schedule.arn
}
