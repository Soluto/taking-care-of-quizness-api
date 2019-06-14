
# Todo Authorized Serverless REST API

This example demonstrates how to setup an [Authorized RESTful Web Services](https://en.wikipedia.org/wiki/Representational_state_transfer#Applied_to_web_services) allowing you to create, and List Todos. DynamoDB is used to store the data, and the Cognito client credentials flow is used to secure the API. This is just an example and of course you could use any data storage as a backend.

## Structure

This service has a separate directory for all the todo operations. For each operation exactly one file exists e.g. `todos/create.js`. In each of these files there is exactly one function which is directly attached to `module.exports`.

The idea behind the `todos` directory is that in case you want to create a service containing multiple resources e.g. users, notes, comments you could do so in the same service. While this is certainly possible you might consider creating a separate service for each resource. It depends on the use-case and your preference.

## Setup

```bash
npm install
```

## Provision Cognito
### Important Terms
* [User Pool](https://docs.aws.amazon.com/cognito/latest/developerguide/cognito-user-identity-pools.html) : A user pool is collections of users. The users can be federated, can be manually set up, or imported. User Pools are the foundational entity in Cognito. You may compare this to a typical AD or LDAP directory.

* [Identity Pools](https://docs.aws.amazon.com/cognito/latest/developerguide/cognito-identity.html) : An identity pool allows access to AWS services via federated or custom identity. This way we do not have to manage a separate directory of users who need to access the dev AWS account.

* [Domain](https://docs.aws.amazon.com/cognito/latest/developerguide/cognito-user-pools-assign-domain.html) : A Domain is tied to a user pool in a 1:1 relationship, and is used to host the signup/login/challenge pages for the auth experience for the application.

* [App Client](https://docs.aws.amazon.com/cognito/latest/developerguide/user-pool-settings-client-apps.html) : A User Pool can have multiple app clients. App Clients are also where we set up OAuth2 grant types. This is similar to OAuth2 clients that can access resources using various grant types. The app client also has a list of associated scopes that it may allow requests for. These scopes are declared by the Resource Server(s) in the User Pool.

* [Resource Server](https://docs.aws.amazon.com/cognito/latest/developerguide/cognito-user-pools-resource-servers.html) : A resource server is where the users’ data resides, and is protected by the configured User Pool. There can be multiple resource servers associated with a single User Pool. Think of a Resource Server as a microservice which handles authenticated requests. By the time the request makes it to the Resource Server, it has an access token which contains information about the authenticated user, and the session. The resource server(s) verify the authenticity and validity of the access token they receive. A resource server has an identifier (usually the URL of the service), and a list of scopes. Scopes are the granular level levels of access - like read, write, admin, etc.

* [JWT](https://jwt.io/) : Cognito access tokens are JWT, which are signed with JWK. The JWT contains standard claims, but can also be extended to contain custom claims.

### Housekeeping Items
* This tutorial leverages the [Cognito IDP](https://docs.aws.amazon.com/cli/latest/reference/cognito-idp/index.html) API. <br/>
* We will add our own resource servers and app clients to a previously created Cognito User Pool (code provided in 01_createUserPool.sh) 
* Be sure to replace to update the USERNAME variable in each of these scripts

### Create Resource Server
[Cognito Resource Server Script](/scripts/02_createResourceServer.sh)<br/>

```bash
#!/usr/bin/env bash
ID=
USERNAME=

AWS_PROFILE=asurion-soluto-nonprod.dev aws cognito-idp create-resource-server \
--region us-east-1 \
--user-pool-id ${ID} \
--identifier "todo-resourceServer-$USERNAME" \
--name "Todo Application Resource Server" \
--scopes "ScopeName=todo.read,ScopeDescription=Get todo item" "ScopeName=todo.write,ScopeDescription=Create todo item"
```

### Create Application Client
[Cognito App Client Script](/scripts/03_createClientApp.sh)<br/>

```bash
#!/bin/sh
ID=
USERNAME=

AWS_PROFILE=asurion-soluto-nonprod.dev aws cognito-idp create-user-pool-client \
--region us-east-1 \
--user-pool-id ${ID} \
--client-name "todoAppClient-$USERNAME" \
--generate-secret \
--refresh-token-validity 1 \
--read-attributes '[ "address","birthdate","email","email_verified","family_name","gender","given_name","locale","middle_name","name","nickname","phone_number","phone_number_verified","picture","preferred_username","profile","updated_at","website","zoneinfo"]' \
--write-attributes '[ "address","birthdate","email","family_name","gender","given_name","locale","middle_name","name","nickname","phone_number","picture","preferred_username","profile","updated_at","website","zoneinfo"]' \
--allowed-o-auth-flows "client_credentials" \
--allowed-o-auth-scopes "todo-resourceServer-${USERNAME}/todo.read" "todo-resourceServer-${USERNAME}/todo.write" \
--supported-identity-providers "COGNITO"

```

### Create Application Client
[Cognito App Client Script](/scripts/03_createClientApp.sh)<br/>

```bash
#!/bin/sh
ID=
USERNAME=

AWS_PROFILE=asurion-soluto-nonprod.dev aws cognito-idp create-user-pool-client \
--region us-east-1 \
--user-pool-id ${ID} \
--client-name "todoAppClient-$USERNAME" \
--generate-secret \
--refresh-token-validity 1 \
--read-attributes '[ "address","birthdate","email","email_verified","family_name","gender","given_name","locale","middle_name","name","nickname","phone_number","phone_number_verified","picture","preferred_username","profile","updated_at","website","zoneinfo"]' \
--write-attributes '[ "address","birthdate","email","family_name","gender","given_name","locale","middle_name","name","nickname","phone_number","picture","preferred_username","profile","updated_at","website","zoneinfo"]' \
--allowed-o-auth-flows "client_credentials" \
--allowed-o-auth-scopes "todo-resourceServer-${USERNAME}/todo.read" "todo-resourceServer-${USERNAME}/todo.write" \
--supported-identity-providers "COGNITO"

```

### Encode Client Secret
Notice that I am using HTTP Basic to send the client_id and client_secret. This is base64(ClientId:ClientSecret).

If you have openssl installed, you can use the script below, if not any free base64 encoder will do. <br/>

Be sure to update the CLIENT_ID and CLIENT_SECRET variables in the script. <br>

[Client Secret Encoder Script](/scripts/05_encodeSecret.sh)<br/>

```bash
#!/bin/sh
CLIENT_ID=''
CLIENT_SECRET=''
echo "${CLIENT_ID}:${CLIENT_SECRET}" | openssl base64
```

### Get Access Token
We will use this token as the Authorization header in our curl commands.<br/>
Notice that we are using the scopes that we create d on the resource server in <br/>
[Step 2](#create-resource-server).


[Get Access Token Script](/scripts/06_getAccessToken.sh)<br/>

```bash
#!/usr/bin/env bash
USERNAME=
ENCODED_ID_AND_SECRET=

curl -X POST \
  https://todo-app-tutorial.auth.us-east-1.amazoncognito.com/oauth2/token \
  -H "authorization: Basic ${ENCODED_ID_AND_SECRET}" \
  -H 'content-type: application/x-www-form-urlencoded' \
  -d "grant_type=client_credentials&client_id=3gusu5inhkape0l2ei5hkffug9&scope=todo-resourceServer-${USERNAME}/todo.read todo-resourceServer-${USERNAME}/todo.write"
```


## Deploy

In order to deploy the endpoint simply run the [Publish Lambdas Script](/scripts/07_publishLambdas.sh)<br/>
Make sure you have logged in to AWS via single-sign-on.

```bash
#!/usr/bin/env bash
cd..
AWS_PROFILE=asurion-soluto-nonprod.dev SLS_DEBUG=* serverless deploy --stage dev
```

The expected result should be similar to:

```bash
Serverless: Packaging service…
Serverless: Uploading CloudFormation file to S3…
Serverless: Uploading service .zip file to S3…
Serverless: Updating Stack…
Serverless: Checking Stack update progress…
Serverless: Stack update finished…

Service Information
service: serverless-rest-api-with-dynamodb
stage: dev
region: us-east-1
api keys:
  None
endpoints:
  POST - https://45wf34z5yf.execute-api.us-east-1.amazonaws.com/dev/todos
  GET - https://45wf34z5yf.execute-api.us-east-1.amazonaws.com/dev/todos
  GET - https://45wf34z5yf.execute-api.us-east-1.amazonaws.com/dev/todos/{id}
  PUT - https://45wf34z5yf.execute-api.us-east-1.amazonaws.com/dev/todos/{id}
  DELETE - https://45wf34z5yf.execute-api.us-east-1.amazonaws.com/dev/todos/{id}
functions:
  serverless-rest-api-with-dynamodb-dev-update: arn:aws:lambda:us-east-1:488110005556:function:serverless-rest-api-with-dynamodb-dev-update
  serverless-rest-api-with-dynamodb-dev-get: arn:aws:lambda:us-east-1:488110005556:function:serverless-rest-api-with-dynamodb-dev-get
  serverless-rest-api-with-dynamodb-dev-list: arn:aws:lambda:us-east-1:488110005556:function:serverless-rest-api-with-dynamodb-dev-list
  serverless-rest-api-with-dynamodb-dev-create: arn:aws:lambda:us-east-1:488110005556:function:serverless-rest-api-with-dynamodb-dev-create
  serverless-rest-api-with-dynamodb-dev-delete: arn:aws:lambda:us-east-1:488110005556:function:serverless-rest-api-with-dynamodb-dev-delete
```

## Usage
Be sure to replace the the variables in the scripts below. <br/>

You can create, and retrieve with the following commands:

### Create a Todo

[Create Todo Script](/scripts/08_writeTodo.sh)<br/>


```bash
#!/usr/bin/env bash
TODO_URL=""
ACCESS_TOKEN=""
API_KEY=""

curl -X POST \
  ${TODO_URL} \
  -H "Authorization: ${ACCESS_TOKEN}" \
  -H "Content-Type: application/json" \
  -H "x-api-key: ${API_KEY}" \
  -d '{"text":"myTodoText"}'
```

Example Result:
```bash
{"text":"Learn Serverless","id":"ee6490d0-aa11e6-9ede-afdfa051af86","createdAt":1479138570824,"checked":false,"updatedAt":1479138570824}%
```

### List all Todos

[List Todos Script](/scripts/09_readTodo.sh)<br/>

```bash
#!/usr/bin/env bash
TODO_URL=""
ACCESS_TOKEN=""
API_KEY=""

curl -X GET \
  ${TODO_URL} \
  -H "Authorization: ${ACCESS_TOKEN}" \
  -H "x-api-key: ${API_KEY}" 
  ```

Example output:
```bash
[{"text":"Deploy my first service","id":"ac90feaa11e6-9ede-afdfa051af86","checked":true,"updatedAt":1479139961304},{"text":"Learn Serverless","id":"206793aa11e6-9ede-afdfa051af86","createdAt":1479139943241,"checked":false,"updatedAt":1479139943241}]%
```

##Cleanup

[Cleanup Scipt](/scripts/10_removeLambdas.sh)<br/>

```bash
#!/usr/bin/env bash
cd ..
AWS_PROFILE=asurion-soluto-nonprod.dev SLS_DEBUG=* serverless remove --stage dev
```






