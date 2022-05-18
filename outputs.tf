output "lambda" {
  value = "${aws_lambda_function.lambda.qualified_arn}"
}

output "node-lambda" {
  value = "${aws_lambda_function.node_lambda.qualified_arn}"
}

output "temp_queue_lambda" {
  value = "${aws_lambda_function.temp_queue_lambda.qualified_arn}"
}

output "sqs-queue-arn" {
  value = "${aws_sqs_queue.terraform_queue.arn}"
}