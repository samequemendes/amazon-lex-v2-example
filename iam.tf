resource "aws_iam_role" "lex_runtime" {
  name = "${var.bot_name}-lex-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Effect    = "Allow",
      Principal = { Service = "lex.amazonaws.com" },
      Action    = "sts:AssumeRole"
    }]
  })
}

resource "aws_iam_role_policy" "lex_invoke_lambda" {
  name = "${var.bot_name}-invoke-lambda"
  role = aws_iam_role.lex_runtime.id
  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Effect   = "Allow",
      Action   = ["lambda:InvokeFunction"],
      Resource = var.lambda_function_arn
    }]
  })
}
