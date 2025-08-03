variable "aws_region" {
  type    = string
  default = "us-east-1"
}

variable "lambda_function_arn" {
  type        = string
  description = "ARN da função Lambda de fulfillment"
}

variable "bot_name" {
  type    = string
  default = "AgendamentoBot"
}
