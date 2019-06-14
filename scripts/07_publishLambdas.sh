#!/usr/bin/env bash
cd ..
AWS_PROFILE=asurion-soluto-nonprod.dev SLS_DEBUG=* serverless deploy --stage dev
