# Continuous Delivery

In order to handle continuous deployments via Github Actions you will need to create an IAM user with programmatic access and the following policy permissions (make sure to replace all the <[0-9a-zA-z-]*> fields with the appropriate information):

IAM Deployment Policy

```json
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
                "cloudformation:Describe*",
                "cloudformation:List*",
                "cloudformation:Get*",
                "cloudformation:CreateStack",
                "cloudformation:UpdateStack",
                "cloudformation:DeleteStack"
            ],
            "Resource": "arn:aws:cloudformation:us-east-1:<aws-account-id>:stack/taking-care-of-quizness-api*/*"
        },
        {
            "Effect": "Allow",
            "Action": [
                "cloudformation:ValidateTemplate"
            ],
            "Resource": "*"
        },
        {
            "Effect": "Allow",
            "Action": [
                "logs:DescribeLogGroups"
            ],
            "Resource": "arn:aws:logs:us-east-1:<aws-account-id>:log-group:/aws/lambda/taking-care-of-quizness-api*:*"
        },
        {
            "Action": [
                "logs:CreateLogGroup",
                "logs:CreateLogStream",
                "logs:DeleteLogGroup",
                "logs:DeleteLogStream",
                "logs:DescribeLogStreams",
                "logs:FilterLogEvents"
            ],
            "Resource": "arn:aws:logs:us-east-1:<aws-account-id>:log-group:/aws/lambda/taking-care-of-quizness-api*:*",
            "Effect": "Allow"
        },
        {
            "Effect": "Allow",
            "Action": [
                "iam:GetRole",
                "iam:PassRole",
                "iam:CreateRole",
                "iam:DeleteRole",
                "iam:DetachRolePolicy",
                "iam:PutRolePolicy",
                "iam:AttachRolePolicy",
                "iam:DeleteRolePolicy"
            ],
            "Resource": [
                "arn:aws:iam::<aws-account-id>:role/taking-care-of-quizness-api*-lambdaRole"
            ]
        },
        {
            "Effect": "Allow",
            "Action": [
                "s3:DeleteObjectVersion",
                "s3:GetObjectVersionTagging",
                "s3:ReplicateTags",
                "s3:RestoreObject",
                "s3:PutObjectVersionTagging",
                "s3:DeleteObjectVersionTagging",
                "s3:ListMultipartUploadParts",
                "s3:ReplicateObject",
                "s3:GetObjectVersionTorrent",
                "s3:PutObject",
                "s3:GetObjectAcl",
                "s3:GetObject",
                "s3:GetObjectTorrent",
                "s3:AbortMultipartUpload",
                "s3:GetObjectVersionAcl",
                "s3:GetObjectTagging",
                "s3:PutObjectTagging",
                "s3:GetObjectVersionForReplication",
                "s3:DeleteObject",
                "s3:ReplicateDelete",
                "s3:GetObjectVersion",
                "s3:ListBucket",
                "s3:GetEncryptionConfiguration",
                "s3:PutEncryptionConfiguration",
                "s3:PutBucketAcl"
            ],
            "Resource": [
                "arn:aws:s3:::taking-care-of-quizness-serverlessdeploymentbuck*"
            ]
        },
        {
            "Effect": "Allow",
            "Action": [
                "apigateway:GET",
                "apigateway:PATCH",
                "apigateway:POST",
                "apigateway:PUT",
                "apigateway:DELETE",
                "apigateway:UpdateRestApiPolicy"
            ],
            "Resource": [
                "arn:aws:apigateway:us-east-1::/restapis/*"
            ]
        },
        {
            "Effect": "Allow",
            "Action": [
                "apigateway:GET",
                "apigateway:PATCH"
            ],
            "Resource": [
                "arn:aws:apigateway:us-east-1::/usageplans/*",
                "arn:aws:apigateway:us-east-1::/apikeys*"
            ]
        },
        {
            "Effect": "Allow",
            "Action": [
                "lambda:GetFunction",
                "lambda:CreateFunction",
                "lambda:DeleteFunction",
                "lambda:UpdateFunctionConfiguration",
                "lambda:UpdateFunctionCode",
                "lambda:ListVersionsByFunction",
                "lambda:PublishVersion",
                "lambda:CreateAlias",
                "lambda:DeleteAlias",
                "lambda:UpdateAlias",
                "lambda:GetFunctionConfiguration",
                "lambda:AddPermission",
                "lambda:RemovePermission",
                "lambda:InvokeFunction"
            ],
            "Resource": [
                "arn:aws:lambda:us-east-1:<aws-account-id>:function:taking-care-of-quizness-api*"
            ]
        },
        {
            "Effect": "Allow",
            "Action": [
                "ec2:DescribeSecurityGroups",
                "ec2:DescribeSubnets",
                "ec2:DescribeVpcs"
            ],
            "Resource": [
                "*"
            ]
        }
    ]
}
```

Once the IAM user has been created you will need to add the AWS_ACCESS_KEY_ID and AWS_SECRET_ACCESS_KEY to your repository's encrypted secrets in order to utilize them in the GitHub Action release workflow.
