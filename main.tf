# Specify the provider and access details
provider "aws" {
  region = "${var.aws_region}"
}

data "aws_caller_identity" "current" {}
data "aws_region" "current" {}

provider "archive" {}

data "archive_file" "zip" {
  type        = "zip"
  source_file = "lambdas/hello_lambda.py"
  output_path = "lambdas/hello_lambda.zip"
}

data "aws_iam_policy_document" "policy" {
  statement {
    sid    = ""
    effect = "Allow"

    principals {
      identifiers = ["lambda.amazonaws.com"]
      type        = "Service"
    }

    actions = [
        "sts:AssumeRole"        
    ]
  }
}

resource "aws_iam_role" "iam_for_lambda" {
  name               = "iam_for_lambda"
  assume_role_policy = "${data.aws_iam_policy_document.policy.json}"
}

data "aws_iam_policy_document" "lambda_invocation_policy" {

  statement {
    effect = "Allow"

    actions = ["lambda:InvokeFunction"]

    resources = ["arn:aws:lambda:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:function:*"]
  }
}



resource "aws_iam_role_policy" "lambda_invoke_role_policy" {
  name   = "lambda-invoke-role-policy"
  role   = "${aws_iam_role.iam_for_lambda.id}"
  policy = "${data.aws_iam_policy_document.lambda_invocation_policy.json}"
}

resource "aws_lambda_function" "lambda" {
  function_name = "hello_lambda"

  filename         = "${data.archive_file.zip.output_path}"
  source_code_hash = "${data.archive_file.zip.output_base64sha256}"

  role    = "${aws_iam_role.iam_for_lambda.arn}"
  handler = "hello_lambda.lambda_handler"
  runtime = "python3.6"

  environment {
    variables = {
      greeting = "Hello"
    }
  }
}

data "archive_file" "node_zip" {
  type        = "zip"
  source_file = "lambdas/hello_node.js"
  output_path = "lambdas/hello_node.zip"
}

resource "aws_lambda_function" "node_lambda" {
  function_name = "hello_node"

  filename         = "${data.archive_file.node_zip.output_path}"
  source_code_hash = "${data.archive_file.node_zip.output_base64sha256}"

  role    = "${aws_iam_role.iam_for_lambda.arn}"
  handler = "hello_node.lambda_Handler"
  runtime = "nodejs14.x"

  environment {
    variables = {
      greeting = "Hello"
    }
  }
}

data "archive_file" "who_node_zip" {
  type        = "zip"
  source_file = "lambdas/who_am_i_greeting.js"
  output_path = "lambdas/who_am_i_greeting.zip"
}

resource "aws_lambda_function" "who_node_lambda" {
  function_name = "who_am_i_greeting"

  filename         = "${data.archive_file.who_node_zip.output_path}"
  source_code_hash = "${data.archive_file.who_node_zip.output_base64sha256}"

  role    = "${aws_iam_role.iam_for_lambda.arn}"
  handler = "who_am_i_greeting.handler"
  runtime = "nodejs14.x"

  environment {
    variables = {
      greeting = "Hello"
    }
  }
}

data "archive_file" "temp_queue_lambda_zip" {
  type        = "zip"
  source_file = "lambdas/temp_queue_lambda.js"
  output_path = "lambdas/temp_queue_lambda.zip"
}

resource "aws_lambda_function" "temp_queue_lambda" {
  function_name = "temp_queue_lambda"

  filename         = "${data.archive_file.temp_queue_lambda_zip.output_path}"
  source_code_hash = "${data.archive_file.temp_queue_lambda_zip.output_base64sha256}"

  role    = "${aws_iam_role.iam_for_lambda.arn}"
  handler = "temp_queue_lambda.handler"
  runtime = "nodejs14.x"

  environment {
    variables = {
      greeting = "TempQueue"
    }
  }
}
resource "aws_sqs_queue" "terraform_queue" {
  name                        = "main-queue.fifo"
  fifo_queue                  = true
  content_based_deduplication = true
}