#!/bin/sh
ID=''
USERNAME='Q'

AWS_PROFILE=asurion-soluto-nonprod.dev aws cognito-idp create-user-pool-client --region us-east-1 --user-pool-id ${ID} --client-name "todoAppClient-$USERNAME" --generate-secret --refresh-token-validity 1 --read-attributes '[ "address","birthdate","email","email_verified","family_name","gender","given_name","locale","middle_name","name","nickname","phone_number","phone_number_verified","picture","preferred_username","profile","updated_at","website","zoneinfo"]' --write-attributes '[ "address","birthdate","email","family_name","gender","given_name","locale","middle_name","name","nickname","phone_number","picture","preferred_username","profile","updated_at","website","zoneinfo"]' --allowed-o-auth-flows "client_credentials" --allowed-o-auth-scopes "todo-resourceServer-${USERNAME}/todo.read" "todo-resourceServer-${USERNAME}/todo.write" --supported-identity-providers "COGNITO"
