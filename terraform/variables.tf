variable "aws_region" {
  description = "AWS region"
  type        = string
  default     = "us-east-1"
}

variable "layer_name" {
  description = "Lambda Layer name"
  type        = string
  default     = "python-utils-layer"
}

variable "lambda_function_name" {
  description = "Lambda function name"
  type        = string
  default     = "lambda-layer-demo"
}