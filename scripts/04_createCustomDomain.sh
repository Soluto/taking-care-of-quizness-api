#!/bin/sh
ID=''
AWS_PROFILE=asurion-soluto-nonprod.dev aws cognito-idp create-user-pool-domain  --domain 'todo-app-tutorial' --user-pool-id ${ID} --region us-east-1

