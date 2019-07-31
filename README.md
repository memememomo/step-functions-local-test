
## 概要

![構成図](https://github.com/memememomo/step-functions-local-test/blob/img/img/Step%20Functions%20Local+SAM%20Local.png?raw=true)

Docker を使用して Step Functions Local を実行する環境です。

## 想定環境

Docker for Mac がインストールされていることを想定しています。

## 実行手順

以下の手順で SAM Local と Step Functions Local のコンテナを起動します。

```bash
# ビルド
$ COMPOSE_PROJECT_NAME=step-functions-local-test docker-compose build

# Lambdaハンドラーのビルド
$ COMPOSE_PROJECT_NAME=step-functions-local-test docker-compose run go-build ./go-build.sh

# サーバ立ち上げ
$ COMPOSE_PROJECT_NAME=step-functions-local-test docker-compose up
```

別コンソールで、以下の手順で Step Functions を実行します。

```bash
# StateMachineを作成
$ aws stepfunctions --endpoint http://localhost:8083 create-state-machine --definition "{\
    \"Comment\": \"A Hello World example of the Amazon States Language using an AWS Lambda Local function\",\
    \"StartAt\": \"HelloWorld\",\
    \"States\": {\
      \"HelloWorld\": {\
        \"Type\": \"Task\",\
        \"Resource\": \"arn:aws:lambda:us-east-1:123456789012:function:HelloWorld\",\
        \"End\": true\
      }\
    }\
  }\
  }}" --name "HelloWorld" --role-arn "arn:aws:iam::012345678901:role/DummyRole"
  
# StateMachineを実行
$ aws stepfunctions --endpoint http://localhost:8083 start-execution --state-machine arn:aws:states:us-east-1:123456789012:stateMachine:HelloWorld
```

コンテナを起動したコンソールで、以下のような出力が表示されたら成功です。

```bash
step-functions-local_1  | 2019-07-31 00:49:58.444: [200] StartExecution <= {"sdkResponseMetadata":null,"sdkHttpMetadata":null,"executionArn":"arn:aws:states:ap-northeast-1:123456789012:execution:HelloWorld:9f49a299-36f7-4b22-95b1-fb7ae816b113","startDate":1564534198424}
step-functions-local_1  | 2019-07-31 00:49:58.483: arn:aws:states:ap-northeast-1:123456789012:execution:HelloWorld:9f49a299-36f7-4b22-95b1-fb7ae816b113 : {"Type":"ExecutionStarted","PreviousEventId":0,"ExecutionStartedEventDetails":{"Input":"{}","RoleArn":"arn:aws:iam::012345678901:role/DummyRole"}}
step-functions-local_1  | 2019-07-31 00:49:58.487: arn:aws:states:ap-northeast-1:123456789012:execution:HelloWorld:9f49a299-36f7-4b22-95b1-fb7ae816b113 : {"Type":"TaskStateEntered","PreviousEventId":0,"StateEnteredEventDetails":{"Name":"HelloWorld","Input":"{}"}}
step-functions-local_1  | 2019-07-31 00:49:58.507: arn:aws:states:ap-northeast-1:123456789012:execution:HelloWorld:9f49a299-36f7-4b22-95b1-fb7ae816b113 : {"Type":"LambdaFunctionScheduled","PreviousEventId":2,"LambdaFunctionScheduledEventDetails":{"Resource":"arn:aws:lambda:us-east-1:123456789012:function:HelloWorld","Input":"{}"}}
step-functions-local_1  | 2019-07-31 00:49:58.508: arn:aws:states:ap-northeast-1:123456789012:execution:HelloWorld:9f49a299-36f7-4b22-95b1-fb7ae816b113 : {"Type":"LambdaFunctionStarted","PreviousEventId":3}
sam-local_1             | 2019-07-31 00:49:58 Invoking main (go1.x)
sam-local_1             |
sam-local_1             | Fetching lambci/lambda:go1.x Docker container image......
sam-local_1             | 2019-07-31 00:50:01 Mounting /Users/uchiko/project/step-functions-local-test/handlers/helloworld as /var/task:ro inside runtime container
sam-local_1             | START RequestId: bf7b22bb-7cc7-1703-a07b-f94434457538 Version: $LATEST
sam-local_1             | END RequestId: bf7b22bb-7cc7-1703-a07b-f94434457538
sam-local_1             | REPORT RequestId: bf7b22bb-7cc7-1703-a07b-f94434457538        Duration: 1.21 ms       Billed Duration: 100 ms Memory Size: 128 MB     Max Memory Used: 5 MB
sam-local_1             | 2019-07-31 00:50:03 172.19.0.3 - - [31/Jul/2019 00:50:03] "POST /2015-03-31/functions/HelloWorld/invocations HTTP/1.1" 200 -
step-functions-local_1  | 2019-07-31 00:50:03.689: arn:aws:states:ap-northeast-1:123456789012:execution:HelloWorld:9f49a299-36f7-4b22-95b1-fb7ae816b113 : {"Type":"LambdaFunctionSucceeded","PreviousEventId":4,"LambdaFunctionSucceededEventDetails":{"Output":"\"Hello World!\""}}
step-functions-local_1  | 2019-07-31 00:50:03.691: arn:aws:states:ap-northeast-1:123456789012:execution:HelloWorld:9f49a299-36f7-4b22-95b1-fb7ae816b113 : {"Type":"TaskStateExited","PreviousEventId":5,"StateExitedEventDetails":{"Name":"HelloWorld","Output":"\"Hello World!\""}}
step-functions-local_1  | 2019-07-31 00:50:03.695: arn:aws:states:ap-northeast-1:123456789012:execution:HelloWorld:9f49a299-36f7-4b22-95b1-fb7ae816b113 : {"Type":"ExecutionSucceeded","PreviousEventId":0,"ExecutionSucceededEventDetails":{"Output":"\"Hello World!\""}}
```
