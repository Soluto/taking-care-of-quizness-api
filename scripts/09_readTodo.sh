#!/usr/bin/env bash
TODO_URL=
ACCESS_TOKEN=
API_KEY=

curl -X GET \
  ${TODO_URL} \
  -H "Authorization: ${ACCESS_TOKEN}" \
  -H "x-api-key: ${API_KEY}" \
