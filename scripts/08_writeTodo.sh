#!/usr/bin/env bash
TODO_URL=
ACCESS_TOKEN=
API_KEY=

curl -X POST \
  ${TODO_URL} \
  -H "Authorization: ${ACCESS_TOKEN}" \
  -H "Content-Type: application/json" \
  -H "x-api-key: ${API_KEY}" \
  -d '{"text":"myTodoText"}'
