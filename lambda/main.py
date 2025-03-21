import boto3
import os
import time
import random

logs_client = boto3.client('logs')
s3_client = boto3.client('s3')

s3_bucket = os.environ['S3_BUCKET']

def lambda_handler(event, context):
    log_groups = logs_client.describe_log_groups()['logGroups']

    for log_group in log_groups:
        log_group_name = log_group['logGroupName']
        print(f"Processing log group: {log_group_name}")

        retries = 0
        max_retries = 5
        backoff_time = 5  # Initial wait time in seconds

        export_task_id = None

        while retries < max_retries:
            try:
                response = logs_client.create_export_task(
                    taskName=f"export-{log_group_name}",
                    logGroupName=log_group_name,
                    fromTime=int((time.time() - 86400) * 1000),  # Past 24 hours
                    to=int(time.time() * 1000),
                    destination=s3_bucket,
                    destinationPrefix=f"logs/{log_group_name}"
                )
                export_task_id = response['taskId']
                print(f" Export task {export_task_id} started for {log_group_name}")

                time.sleep(random.randint(10, 20))
                break  # Success, exit retry loop

            except logs_client.exceptions.LimitExceededException:
                print(f" LimitExceededException for {log_group_name}. Retrying in {backoff_time} sec...")
                time.sleep(backoff_time)
                backoff_time *= 2  # **Exponential Backoff**
                retries += 1

            except Exception as e:
                print(f" Error processing {log_group_name}: {str(e)}")
                return {"status": "Failed"}

        if not export_task_id:
            print(f" Failed to start export task for {log_group_name}")
            continue

        if wait_for_export_completion(export_task_id):
            print(f" Export completed for {log_group_name}")

            if verify_s3_logs(log_group_name):
                print(f" Logs successfully uploaded to S3 for {log_group_name}")

               
                if log_group_name == f"/aws/lambda/{context.function_name}":
                    print(f" Skipping deletion of Lambda log group: {log_group_name}")
                else:
                    delete_cloudwatch_logs(log_group_name)
            else:
                print(f" Logs not found in S3 for {log_group_name}, skipping deletion")
        else:
            print(f" Export failed for {log_group_name}, skipping deletion")

    return {"status": "Completed"}

def wait_for_export_completion(task_id, max_wait=300, interval=10):
    elapsed_time = 0
    while elapsed_time < max_wait:
        response = logs_client.describe_export_tasks(taskId=task_id)
        status = response['exportTasks'][0]['status']['code']

        if status == "COMPLETED":
            return True
        elif status in ["FAILED", "CANCELLED"]:
            return False

        time.sleep(interval)
        elapsed_time += interval
    return False

def verify_s3_logs(log_group_name):
    prefix = f"logs/{log_group_name}/"
    response = s3_client.list_objects_v2(Bucket=s3_bucket, Prefix=prefix)

    return "Contents" in response  # Returns True if logs exist

def delete_cloudwatch_logs(log_group_name):
    try:
        logs_client.delete_log_group(logGroupName=log_group_name)
        print(f" Deleted log group: {log_group_name}")
    except Exception as e:
        print(f" Failed to delete log group {log_group_name}: {str(e)}")
