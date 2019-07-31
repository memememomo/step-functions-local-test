#!/usr/bin/env bash

dep ensure
cd ./handlers/helloworld/ && CGO_ENABLED=0 GOOS=linux go build -v -installsuffix cgo -o main .
