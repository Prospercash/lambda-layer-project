output "lambda_function_name" {
  value = aws_lambda_function.demo.function_name
}

output "lambda_function_arn" {
  value = aws_lambda_function.demo.arn
}

output "lambda_layer_arn" {
  value = aws_lambda_layer_version.python_utils.arn
}