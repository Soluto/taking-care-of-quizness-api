#!/usr/bin/env bash
QUESTIONS_URL=
ACCESS_TOKEN=
API_KEY=

curl -X GET \
  ${QUESTIONS_URL} \
  -H "Authorization: ${ACCESS_TOKEN}" \
  -H "x-api-key: ${API_KEY}" \
