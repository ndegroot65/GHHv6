#!/bin/bash

AWS=`which aws`
JQ=`which jq`
if ! test -f "$AWS"; then
	echo "AWS cli is required for execution, please install and try again"
	exit
fi
if ! test -f "$JQ"; then
	echo "JQ is required for execution, please install and try again"
fi

aws iam create-user --user-name ghh  | tee user-out.json
aws iam create-access-key --user-name ghh  | tee key-out.json
aws iam create-group --group-name ghh-group | tee group-out.json
aws iam add-user-to-group --user-name ghh --group-name ghh-group 
aws iam attach-group-policy --group-name ghh-group --policy-arn arn:aws:iam::aws:policy/AmazonEC2FullAccess
aws iam attach-group-policy --group-name ghh-group --policy-arn arn:aws:iam::aws:policy/AmazonS3FullAccess

echo -e "[ghh]\naws_access_key_id = `jq .AccessKey.AccessKeyId key-out.json | cut -f 2 -d '"'`\naws_secret_access_key = `jq .AccessKey.SecretAccessKey key-out.json | cut -f 2 -d '"'`\n" >> ~/.aws/credentials

echo "Provisioning complete"