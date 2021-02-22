#!/usr/bin/env bash
ID=''
aws cognito-idp create-resource-server --region us-east-1 --user-pool-id ${ID} --identifier "quiz-resourceServer" --name "Quiz Application Resource Server" --scopes "ScopeName=questions.read,ScopeDescription=Get all questions" "ScopeName=questions.write,ScopeDescription=Create quiz question"
