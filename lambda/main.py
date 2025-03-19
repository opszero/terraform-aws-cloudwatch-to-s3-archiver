import boto3
import time
import os

# Initialize AWS Clients
logs_client = boto3.client("logs")
s3_bucket = os.environ["S3_BUCKET"]  # Define in Lambda environment variables


def get_all_log_groups():
    """Fetch all CloudWatch Log Groups"""
    log_groups = []
    paginator = logs_client.get_paginator("describe_log_groups")
    for page in paginator.paginate():
        log_groups.extend(page["logGroups"])
    return log_groups


def export_log_group_to_s3(log_group_name, destination_prefix):
    """Export logs from a log group to S3"""
    export_task = logs_client.create_export_task(
        logGroupName=log_group_name,
        destination=s3_bucket,
        destinationPrefix=destination_prefix,
        fromTime=int(time.time() * 1000) - (365 * 24 * 60 * 60 * 1000),  # Last 1 year
        to=int(time.time() * 1000),  # Till now
    )
    return export_task["taskId"]


def wait_for_export_completion(task_id):
    """Wait until the export task is completed"""
    while True:
        response = logs_client.describe_export_tasks(taskId=task_id)
        status = response["exportTasks"][0]["status"]["code"]
        if status in ["COMPLETED", "FAILED"]:
            return status
        time.sleep(10)  # Check every 10 seconds


def delete_log_group(log_group_name):
    """Delete the CloudWatch Log Group"""
    logs_client.delete_log_group(logGroupName=log_group_name)


def lambda_handler(event, context):
    """Lambda Function Handler"""
    log_groups = get_all_log_groups()

    for log_group in log_groups:
        log_group_name = log_group["logGroupName"]
        print(f"Processing log group: {log_group_name}")

        # Start Export
        try:
            task_id = export_log_group_to_s3(log_group_name, log_group_name.strip("/"))
            print(f"Export task {task_id} started for {log_group_name}")

            # Wait for Export Completion
            status = wait_for_export_completion(task_id)

            if status == "COMPLETED":
                print(f"Export completed for {log_group_name}, deleting log group...")
                delete_log_group(log_group_name)
                print(f"Deleted log group: {log_group_name}")
            else:
                print(f"Export failed for {log_group_name}")

        except Exception as e:
            print(f"Error processing {log_group_name}: {e}")

    return {"status": "Completed"}
