FROM python:3.5-alpine

ENV PYTHONUSERBASE=/usr/local

RUN apk add --no-cache py-pip git bash gcc libc-dev && \
    pip install --upgrade pip && \
    pip install --user awscli==1.16.76 aws-sam-cli==0.9.0

WORKDIR /var/opt
COPY . /var/opt/

EXPOSE 3001
