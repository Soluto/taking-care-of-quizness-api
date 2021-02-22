#!/usr/bin/env bash
QUESTIONS_URL=
ACCESS_TOKEN=
API_KEY=

curl -X POST \
  ${QUESTIONS_URL} \
  -H "Authorization: ${ACCESS_TOKEN}" \
  -H "Content-Type: application/json" \
  -H "x-api-key: ${API_KEY}" \
  -d '{"text":"myQuestionText", answers: []}'
