#!/bin/bash

sam local start-lambda \
  --docker-volume-basedir "${VOLUME}" \
  --docker-network step-functions-local-test_net \
  --host 0.0.0.0 \
  --template template.yml

