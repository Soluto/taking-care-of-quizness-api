#!/usr/bin/env bash
cd ..
AWS_PROFILE=asurion-soluto-nonprod.dev SLS_DEBUG=* serverless remove --stage dev
