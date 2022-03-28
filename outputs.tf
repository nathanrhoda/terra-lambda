output "lambda" {
  value = "${aws_lambda_function.lambda.qualified_arn}"
}

output "node-lambda" {
  value = "${aws_lambda_function.node_lambda.qualified_arn}"
}