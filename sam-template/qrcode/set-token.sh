#!/bin/bash

# Get the directory path of the script
script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Read the token file content into variables
access_key=$(jq -r '.Credentials.AccessKeyId' "$script_dir/token.txt")
secret_key=$(jq -r '.Credentials.SecretAccessKey' "$script_dir/token.txt")
session_token=$(jq -r '.Credentials.SessionToken' "$script_dir/token.txt")


# Export the values as environment variables
export AWS_ACCESS_KEY_ID="$access_key"
export AWS_SECRET_ACCESS_KEY="$secret_key"
export AWS_SESSION_TOKEN="$session_token"