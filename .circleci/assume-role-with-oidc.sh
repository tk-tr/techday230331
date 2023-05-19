#!/usr/bin/env bash

set -xeuo pipefail

DURATION_SECONDS=$((60*15))

aws_sts_credentials=`aws sts assume-role-with-web-identity \
  --role-arn $1 \
  --web-identity-token $2 \
  --role-session-name "circle-ci-session" \
  --duration-seconds ${DURATION_SECONDS} \
  --query "Credentials" \
  --output "json"`

cat <<EOT > "$(dirname $0)/aws-envs.sh"
export AWS_ACCESS_KEY_ID="$(echo $aws_sts_credentials | jq -r '.AccessKeyId')"
export AWS_SECRET_ACCESS_KEY="$(echo $aws_sts_credentials | jq -r '.SecretAccessKey')"
export AWS_SESSION_TOKEN="$(echo $aws_sts_credentials | jq -r '.SessionToken')"
EOT
