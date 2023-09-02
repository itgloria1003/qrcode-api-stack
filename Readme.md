# QR Code Generator

Following is notes on the guide <https://docs.aws.amazon.com/serverless-application-model/latest/developerguide/serverless-getting-started-hello-world.html>

## Prerequisite
### install AWS cli

<https://docs.aws.amazon.com/cli/latest/userguide/getting-started-install.html>

// for mac

```
brew install awscli
```

<https://docs.aws.amazon.com/serverless-application-model/latest/developerguide/install-sam-cli.html>

1. Install sam cli

```
brew tap aws/tap
brew install aws-sam-cli
```

1. install docker
<https://docs.docker.com/docker-for-mac/install/>

1. create IAM admin user and assume role for SAM deployment using local developer profile

<https://docs.aws.amazon.com/serverless-application-model/latest/developerguide/prerequisites.html#prerequisites-create-user>
<https://docs.aws.amazon.com/IAM/latest/UserGuide/getting-set-up.html#create-an-admin>

- create policy `deploy-local-sam` for SAM deployment 
e.g. API gateway , Cloudformation , S3 , Lambda

- create IAM user `local-developer` for local development and get the access key and secret key
- create `localDeveloperSamDeployment` role and grant trusted relationship to `local-developer` user
- attach `deploy-local-sam` policy to `localDeveloperSamDeployment` role

```text
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "Statement1",
            "Effect": "Allow",
            "Principal": {
                "AWS": "arn:aws:iam::864682396680:user/local-developer"
            },
            "Action": "sts:AssumeRole"
        }
    ]
```

1. You can use temporary security credentials with the AWS CLI. This can be useful for testing policies.
<https://docs.aws.amazon.com/IAM/latest/UserGuide/id_credentials_temp_use-resources.html#using-temp-creds-sdk-cli>

```bash
aws sts assume-role --role-arn arn:aws:iam::864682396680:role/localDeveloperSamDeployment --role-session-name "deployment-session1" --profile local-developer > token.txt
```

1. set the environment variable for the local development

run the `. set-token.sh` or `source set-token.sh` To ensure that the environment variables are set in the parent shell, you can source the script instead of executing it as a separate process.

- verify the role has been assumed using the variable exported  
  
```bash
aws sts get-caller-identity
```

Following will be shown
```text
{
    "UserId": "AROA4SUYWJQEJIUTKM6YP:deployment-session1",
    "Account": "864682396680",
    "Arn": "arn:aws:sts::864682396680:assumed-role/localDeveloperSamDeployment/deployment-session1"
}
```

1. start  a python 3.8 environment , <https://docs.aws.amazon.com/lambda/latest/dg/lambda-runtimes.html>

```bash
sam init --runtime python3.8 --name qrcode 
```

Note: Make sure the appropriate runtime install (via Conda) and the "Select appropriate intrepter" for the runtime

go to the folder and start the local api gateway

## deploy guided for the first time

```bash
sam deploy --guided
```


## describe the deployed stack 
```bash
sam list stack-outputs --region ap-northeast-1

```
```bash
sam delete --stack-name qrcode --region ap-northeast-1
```

1. build and start the local api gateway

```bash
sam build && sam local start-api
```


### (Optional) export cloudformation template 
```bash

sam package --output-template-file packaged.yaml --s3-bucket  cf-sam-deployment 
```

Replace `template.yaml` with the name of your SAM template file, and `cloudformation.yaml` with the desired name for your CloudFormation template file.

This command will process your SAM template, resolve SAM-specific resources, and generate a CloudFormation template (`cloudformation.yaml`) that represents your serverless application.



Fortunately, the SAM source code contains a script for converting a SAM template to a CFT. Clone the SAM repo and then install the Python dependencies.

git clone https://github.com/aws/serverless-application-model.git
pip install -r serverless-application-model/requirements/base.txt
pip install pyyaml


python serverless-application-model/bin/sam-translate.py \
  --template-file=packaged.yaml \
  --output-template=cft.json


The resulting CFT will be in JSON format, so if you're at all sane, you'll now convert this JSON file to YAML 😄. The cfn-flip tool was written to do exactly this.

pip install cfn-flip
cfn-flip -i json -o yaml cft.json cft.yaml
rm cft.json

## Reference 
<https://www.packetmischief.ca/2020/12/30/converting-from-aws-sam-to-cloudformation/>

## troubleshoot

   In the docker settings go to Advanced -> Allow the default Docker socket to be used (requires password) and restart docker or Mac. It works for me
   \

   specific environment for build
