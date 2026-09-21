from utils.helper import format_message


def lambda_handler(event, context):
    return format_message("Hello from Lambda Layer!")