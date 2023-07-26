1. install AWS cli 

https://docs.aws.amazon.com/cli/latest/userguide/getting-started-install.html


2. install SAM 


https://docs.aws.amazon.com/serverless-application-model/latest/developerguide/install-sam-cli.html

3. configure to use the profile 
   ``` 
   aws configure --profile local-developer

   aws sts get-caller-identity --profile local-developer
   ``` 

Following will be shown 
``` 
{
    "UserId": "AIDA4SUYWJQEBQJJBRJRJ",
    "Account": "864682396680",
    "Arn": "arn:aws:iam::864682396680:user/local-developer"
}
```    


4. start  a python 3.8 environment , https://docs.aws.amazon.com/lambda/latest/dg/lambda-runtimes.html 
``` 
sam init --runtime python3.8 --name qrcode 

``` 

sam build && sam local start-api

 
5. generate cloudformation template 
   ``` 
   sam package --template-file template.yaml --output-template-file cloudformation-template.yaml
   ``` 

   ## troubleshoot 
   In the docker settings go to Advanced -> Allow the default Docker socket to be used (requires password) and restart docker or Mac. It works for me