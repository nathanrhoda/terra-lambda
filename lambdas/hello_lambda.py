import os


def lambda_handler(event, context):
    return "{} from Lambda Woof!".format(os.environ['greeting'])