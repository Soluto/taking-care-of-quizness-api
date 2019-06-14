#!/usr/bin/env bash
ID='us-east-1_6a6sOQeWH'
USERNAME=

AWS_PROFILE=asurion-soluto-nonprod.dev aws cognito-idp create-resource-server --region us-east-1 --user-pool-id ${ID} --identifier "todo-resourceServer-$USERNAME" --name "Todo Application Resource Server" --scopes "ScopeName=todo.read,ScopeDescription=Get todo item" "ScopeName=todo.write,ScopeDescription=Create todo item"
