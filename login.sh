#!/bin/bash

# Load environment variables from .env file (optional)
if [ -f .env ]; then
  source .env
fi

# Check that required variables are defined
: "${AUTH_URL:?You must define AUTH_URL}"
: "${AUTH_HEADER:?You must define AUTH_HEADER}"
: "${TOKEN_DISPLAY_URL:?You must define TOKEN_DISPLAY_URL}"
: "${OC_SERVER:?You must define OC_SERVER}"

# 1. Make the GET request and capture the response
response=$(curl -s -L -X GET "$AUTH_URL" \
	-H "Authorization: $AUTH_HEADER" \
	-c mycookies.txt)

# 2. Extract 'code' and 'csrf' values
code=$(echo "$response" | grep -oP 'name="code" value="\K[^"]+')
csrf=$(echo "$response" | grep -oP 'name="csrf" value="\K[^"]+')

if [ -z "$code" ] || [ -z "$csrf" ]; then
  echo "Could not extract 'code' or 'csrf'."
  exit 1
fi

# 3. Make the POST request to obtain the token
post_response=$(curl -s -L -X POST "$TOKEN_DISPLAY_URL" \
  -H 'Content-Type: application/x-www-form-urlencoded' \
  -b mycookies.txt \
  -d "code=$code" \
  -d "csrf=$csrf")

# 4. Extract token value from <code>...</code> tags
code_value=$(echo "$post_response" | grep -oP '<code>\K[^<]+')

if [ -n "$code_value" ]; then
  echo "oc login --token=$code_value --server=$OC_SERVER"
  oc login --token="$code_value" --server="$OC_SERVER"
else
  echo "Token not found in the POST response."
fi
