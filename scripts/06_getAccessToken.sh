#!/usr/bin/env bash
USERNAME=
ENCODED_ID_AND_SECRET=

curl -X POST \
  https://todo-app-tutorial.auth.us-east-1.amazoncognito.com/oauth2/token \
  -H "authorization: Basic ${ENCODED_ID_AND_SECRET}" \
  -H 'content-type: application/x-www-form-urlencoded' \
  -d "grant_type=client_credentials&client_id=3gusu5inhkape0l2ei5hkffug9&scope=todo-resourceServer-${USERNAME}/todo.read todo-resourceServer-${USERNAME}/todo.write"


