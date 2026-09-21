data "archive_file" "lambda_layer" {
  type        = "zip"
  source_dir  = "${path.module}/../layer"
  output_path = "${path.module}/lambda_layer.zip"
}

data "archive_file" "lambda_function" {
  type        = "zip"
  source_file = "${path.module}/../lambda/lambda_function.py"
  output_path = "${path.module}/lambda_function.zip"
}


resource "aws_lambda_layer_version" "python_utils" {
  filename            = data.archive_file.lambda_layer.output_path
  layer_name          = var.layer_name
  compatible_runtimes = ["python3.12"]

  source_code_hash = data.archive_file.lambda_layer.output_base64sha256
}


resource "aws_iam_role" "lambda_role" {
  name = "${var.lambda_function_name}-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"

    Statement = [
      {
        Effect = "Allow"

        Principal = {
          Service = "lambda.amazonaws.com"
        }

        Action = "sts:AssumeRole"
      }
    ]
  })
}


resource "aws_iam_role_policy_attachment" "lambda_basic_execution" {
  role       = aws_iam_role.lambda_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}


resource "aws_lambda_function" "demo" {
  function_name = var.lambda_function_name

  filename         = data.archive_file.lambda_function.output_path
  source_code_hash = data.archive_file.lambda_function.output_base64sha256

  handler = "lambda_function.lambda_handler"
  runtime = "python3.12"

  role = aws_iam_role.lambda_role.arn

  layers = [
    aws_lambda_layer_version.python_utils.arn
  ]
}