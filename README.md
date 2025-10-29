<!-- BEGIN_TF_DOCS -->

## Providers

| Name | Version |
|------|---------|
| <a name="provider_archive"></a> [archive](#provider\_archive) | n/a |
| <a name="provider_aws"></a> [aws](#provider\_aws) | n/a |
## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_archive_s3_bucket"></a> [archive\_s3\_bucket](#input\_archive\_s3\_bucket) | S3 bucket name for archiving CloudWatch logs | `string` | `"log-group-to-s3-archiver"` | no |
| <a name="input_enable_event_rule"></a> [enable\_event\_rule](#input\_enable\_event\_rule) | Enable or disable CloudWatch Event Rule for Lambda | `bool` | `true` | no |
| <a name="input_enable_lambda"></a> [enable\_lambda](#input\_enable\_lambda) | Enable or disable Lambda function creation | `bool` | `true` | no |
| <a name="input_enable_s3"></a> [enable\_s3](#input\_enable\_s3) | Enable or disable S3 bucket creation | `bool` | `true` | no |
| <a name="input_enabled"></a> [enabled](#input\_enabled) | Globally enable or disable the entire module | `bool` | `true` | no |
| <a name="input_event_rule_name"></a> [event\_rule\_name](#input\_event\_rule\_name) | Name of the CloudWatch event rule | `string` | `"log_archiver_schedule"` | no |
| <a name="input_lambda_function_name"></a> [lambda\_function\_name](#input\_lambda\_function\_name) | Name of the Lambda function | `string` | `"cloudwatch_log_archiver"` | no |
| <a name="input_lambda_memory_size"></a> [lambda\_memory\_size](#input\_lambda\_memory\_size) | Memory size for Lambda function | `number` | `256` | no |
| <a name="input_lambda_policy_name"></a> [lambda\_policy\_name](#input\_lambda\_policy\_name) | IAM Policy name for Lambda function | `string` | `"log_archiver_policy"` | no |
| <a name="input_lambda_role_name"></a> [lambda\_role\_name](#input\_lambda\_role\_name) | IAM Role name for Lambda function | `string` | `"log_archiver_role"` | no |
| <a name="input_lambda_runtime"></a> [lambda\_runtime](#input\_lambda\_runtime) | Runtime for the Lambda function | `string` | `"python3.13"` | no |
| <a name="input_lambda_timeout"></a> [lambda\_timeout](#input\_lambda\_timeout) | Timeout for Lambda function | `number` | `900` | no |
| <a name="input_schedule_expression"></a> [schedule\_expression](#input\_schedule\_expression) | Schedule expression for CloudWatch event rule | `string` | `"rate(1 day)"` | no |
## Resources

| Name | Type |
|------|------|
| [aws_cloudwatch_event_rule.schedule](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_event_rule) | resource |
| [aws_cloudwatch_event_target.trigger_lambda](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_event_target) | resource |
| [aws_iam_policy.lambda_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_policy) | resource |
| [aws_iam_role.lambda_role](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role_policy_attachment.lambda_attach](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_lambda_function.log_archiver](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lambda_function) | resource |
| [aws_lambda_permission.allow_cloudwatch](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lambda_permission) | resource |
| [aws_s3_bucket.log_archive](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket) | resource |
| [aws_s3_bucket_policy.log_archive_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_policy) | resource |
| [aws_s3_bucket_public_access_block.log_archive](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_public_access_block) | resource |
| [archive_file.function](https://registry.terraform.io/providers/hashicorp/archive/latest/docs/data-sources/file) | data source |
| [aws_caller_identity.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/caller_identity) | data source |
| [aws_region.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/region) | data source |
## Outputs

| Name | Description |
|------|-------------|
| <a name="output_cloudwatch_event_rule_arn"></a> [cloudwatch\_event\_rule\_arn](#output\_cloudwatch\_event\_rule\_arn) | The ARN of the CloudWatch Event Rule |
| <a name="output_cloudwatch_event_rule_name"></a> [cloudwatch\_event\_rule\_name](#output\_cloudwatch\_event\_rule\_name) | The name of the CloudWatch Event Rule |
| <a name="output_iam_policy_arn"></a> [iam\_policy\_arn](#output\_iam\_policy\_arn) | The ARN of the IAM policy for Lambda |
| <a name="output_iam_role_name"></a> [iam\_role\_name](#output\_iam\_role\_name) | The name of the IAM role assigned to Lambda |
| <a name="output_lambda_function_arn"></a> [lambda\_function\_arn](#output\_lambda\_function\_arn) | The ARN of the Lambda function |
| <a name="output_lambda_function_name"></a> [lambda\_function\_name](#output\_lambda\_function\_name) | The name of the Lambda function |
| <a name="output_s3_bucket_arn"></a> [s3\_bucket\_arn](#output\_s3\_bucket\_arn) | The ARN of the log archive S3 bucket |
| <a name="output_s3_bucket_name"></a> [s3\_bucket\_name](#output\_s3\_bucket\_name) | The name of the log archive S3 bucket |
# 🚀 Built by opsZero!

<a href="https://opszero.com"><img src="https://opszero.com/img/common/opsZero-Logo-Large.webp" width="300px"/></a>

[opsZero](https://opszero.com) provides software and consulting for Cloud + AI. With our decade plus of experience scaling some of the world’s most innovative companies we have developed deep expertise in Kubernetes, DevOps, FinOps, and Compliance.

Our software and consulting solutions enable organizations to:

- migrate workloads to the Cloud
- setup compliance frameworks including SOC2, HIPAA, PCI-DSS, ITAR, FedRamp, CMMC, and more.
- FinOps solutions to reduce the cost of running Cloud workloads
- Kubernetes optimized for web scale and AI workloads
- finding underutilized Cloud resources
- setting up custom AI training and delivery
- building data integrations and scrapers
- modernizing onto modern ARM based processors

We do this with a high-touch support model where you:

- Get access to us on Slack, Microsoft Teams or Email
- Get 24/7 coverage of your infrastructure
- Get an accelerated migration to Kubernetes

Please [schedule a call](https://calendly.com/opszero-llc/discovery) if you need support.

<br/><br/>

<div style="display: block">
  <img src="https://opszero.com/img/common/aws-advanced.png" alt="AWS Advanced Tier" width="150px" >
  <img src="https://opszero.com/img/common/aws-devops-competency.png" alt="AWS DevOps Competency" width="150px" >
  <img src="https://opszero.com/img/common/aws-eks.png" alt="AWS EKS Delivery" width="150px" >
  <img src="https://opszero.com/img/common/aws-public-sector.png" alt="AWS Public Sector" width="150px" >
</div>
<!-- END_TF_DOCS -->