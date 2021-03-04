#!/usr/bin/env bash

#user to be added to user pool for testing
cognitoUserName=q.sawyers

userPoolId=$(AWS_PROFILE=asurion-soluto-nonprod.dev aws cognito-idp create-user-pool --pool-name "taking-care-of-quizness" --region us-east-1 | jq .UserPool.Id -r );

AWS_PROFILE=asurion-soluto-nonprod.dev aws cognito-idp create-resource-server --region us-east-1 --user-pool-id ${userPoolId} --identifier "quizResourceServer" --name "Quiz Application Resource Server" --scopes "ScopeName=questions.read,ScopeDescription=Get all questions" "ScopeName=questions.write,ScopeDescription=Create quiz question"

AWS_PROFILE=asurion-soluto-nonprod.dev aws cognito-idp create-user-pool-client --region us-east-1 --user-pool-id ${userPoolId} --client-name "quiznessAppClient" --generate-secret --refresh-token-validity 1 --callback-urls '["https://example.com"]' --read-attributes '[ "address","birthdate","email","email_verified","family_name","gender","given_name","locale","middle_name","name","nickname","phone_number","phone_number_verified","picture","preferred_username","profile","updated_at","website","zoneinfo"]' --write-attributes '[ "address","birthdate","email","family_name","gender","given_name","locale","middle_name","name","nickname","phone_number","picture","preferred_username","profile","updated_at","website","zoneinfo"]' --allowed-o-auth-flows "code" --allowed-o-auth-scopes "quizResourceServer/questions.read" "quizResourceServer/questions.write" --supported-identity-providers "COGNITO"

AWS_PROFILE=asurion-soluto-nonprod.dev aws cognito-idp create-user-pool-domain  --domain 'taking-care-of-quizness' --user-pool-id ${userPoolId} --region us-east-1

AWS_PROFILE=asurion-soluto-nonprod.dev aws cognito-idp admin-create-user --region us-east-1 --user-pool-id ${userPoolId} --username ${cognitoUserName} --temporary-password Passwoed1234!

