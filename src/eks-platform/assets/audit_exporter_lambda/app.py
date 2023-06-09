"""
{
  "messageType": "DATA_MESSAGE",
  "owner": "123456789012",
  "logGroup": "log_group_name",
  "logStream": "log_stream_name",
  "subscriptionFilters": [
    "subscription_filter_name"
  ],
  "logEvents": [
    {
      "id": "01234567890123456789012345678901234567890123456789012345",
      "timestamp": 1510109208016,
      "message": "log message 1"
    },
    {
      "id": "01234567890123456789012345678901234567890123456789012345",
      "timestamp": 1510109208017,
      "message": "log message 2"
    }
    ...
  ]
}
"""

import json
import boto3
import csv
import os
import time
import pandas as pd

from gzip import decompress
from base64 import b64decode

logs = boto3.client('logs')
s3 = boto3.resource('s3')

BUCKET_NAME = os.environ['BUCKET_NAME']

def to_azure_sentinel(events, path):
    format = {
        "index": False,
        "header": False,
        "compression": 'gzip',
        "sep": ' ',
        "escapechar": ' ',
        "doublequote": False,
        "quoting": csv.QUOTE_NONE
    }
    data = pd.DataFrame(events)
    data['timestamp'] = pd.to_datetime(data['timestamp'], unit='ms')
    data['timestamp'] = data['timestamp'].dt.strftime('%Y-%m-%dT%H:%M:%S.%f').str[:-3]+'Z'
    return data.to_csv(path, **format)


def lambda_handler(event, context):
    meta_raw = decompress(b64decode(event['awslogs']['data']))
    meta = json.loads(meta_raw)

    try:
        tmp_filepath = f'/tmp/{meta["logStream"]}'
        s3_filepath = f'{meta["logGroup"]}/{meta["logStream"]}/{time.time()}.csv.gz'
        to_azure_sentinel(meta['logEvents'], tmp_filepath)
        s3.Bucket(BUCKET_NAME).upload_file(tmp_filepath, s3_filepath)
    except Exception as e:
        print(f'Error exporting {meta["logGroup"]}: {getattr(e, "message", repr(e))}')
