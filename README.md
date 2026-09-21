# AWS Lambda Layer CI/CD with Terraform and GitHub Actions

## 📌 Project Overview

This project demonstrates how to create, deploy, and manage an **AWS Lambda Layer** using **Terraform** and **GitHub Actions**.

The Lambda Layer contains reusable Python utility code that can be shared across Lambda functions.

Terraform is used to create the AWS infrastructure, while GitHub Actions automatically validates, plans, and deploys the infrastructure whenever changes are pushed to the `main` branch.

---

## 🏗️ Architecture

```text
                         GitHub Repository
                                │
                                │ git push
                                ▼
                       GitHub Actions
                                │
                  ┌─────────────┴─────────────┐
                  │                           │
             Terraform                    AWS Credentials
                  │
                  ▼
             AWS Infrastructure
                  │
        ┌─────────┴──────────┐
        │                    │
        ▼                    ▼
 Lambda Function        Lambda Layer
        │                    │
        │                    ▼
        │              Python Utilities
        │                    │
        └────────────┬───────┘
                     │
                     ▼
                 IAM Role
```

---

## 🎯 Project Objectives

The project was created to demonstrate:

* Creating an AWS Lambda Layer
* Creating reusable Python utility code
* Deploying the Lambda Layer with Terraform
* Creating an AWS Lambda function
* Attaching a Lambda Layer to a Lambda function
* Configuring IAM permissions
* Using Git and GitHub for source control
* Creating a GitHub Actions CI/CD pipeline
* Automatically deploying infrastructure to AWS
* Understanding the benefits of Lambda Layers

---

## 🛠️ Technologies Used

| Technology        | Purpose                  |
| ----------------- | ------------------------ |
| AWS Lambda        | Serverless compute       |
| AWS Lambda Layers | Reusable Python code     |
| AWS IAM           | Permissions and security |
| Terraform         | Infrastructure as Code   |
| Git               | Version control          |
| GitHub            | Source-code repository   |
| GitHub Actions    | CI/CD automation         |
| Python            | Lambda and Layer code    |
| Ubuntu/WSL        | Development environment  |

---

# 📁 Project Structure

```text
lambda-layer-project/
│
├── layer/
│   └── python/
│       └── utils/
│           ├── __init__.py
│           └── helper.py
│
├── lambda/
│   └── lambda_function.py
│
├── terraform/
│   ├── provider.tf
│   ├── variables.tf
│   ├── main.tf
│   └── outputs.tf
│
├── .github/
│   └── workflows/
│       └── deploy-layer.yml
│
├── .gitignore
└── README.md
```

---

# 🧩 How Lambda Layers Work

A Lambda Layer is a separate package containing code or dependencies that can be reused by one or more Lambda functions.

For example, instead of putting the same utility code into several Lambda functions:

```text
Lambda 1 ──┐
Lambda 2 ──┤
Lambda 3 ──┼──> Same Lambda Layer
Lambda 4 ──┤
Lambda 5 ──┘
```

The Lambda functions can share the same Layer.

### Simple analogy

Think of a school.

* **Lambda function** = Teacher
* **Lambda Layer** = Shared equipment room
* **Python utility** = Tool in the equipment room
* **IAM** = Security guard
* **Terraform** = Building blueprint
* **GitHub Actions** = Automatic maintenance worker

Instead of every teacher carrying the same tools, the school keeps the tools in a shared room.

The teachers can access the tools whenever they need them.

---

# 🐍 Lambda Layer Code

The Layer contains:

```text
layer/
└── python/
    └── utils/
        ├── __init__.py
        └── helper.py
```

The `helper.py` file contains a reusable function:

```python
def format_message(message):
    return {
        "status": "success",
        "message": message
    }
```

---

# ⚡ Lambda Function

The Lambda function imports the utility from the Layer:

```python
from utils.helper import format_message


def lambda_handler(event, context):
    return format_message("Hello from Lambda Layer!")
```

The Lambda function does not contain `helper.py`.

Instead, it gets the utility from the attached Lambda Layer.

---

# 🏗️ Terraform

Terraform is used to create and configure the AWS infrastructure.

The Terraform configuration creates:

```text
AWS Lambda Layer
        │
        ├── Python utilities
        │
        ▼
AWS Lambda Function
        │
        ▼
IAM Execution Role
```

Terraform also packages the Layer and Lambda function into ZIP files before deployment.

---

# 🔐 IAM

The Lambda function requires an IAM execution role.

The project creates an IAM role that allows Lambda to execute and write logs to Amazon CloudWatch.

The project uses the AWS managed policy:

```text
AWSLambdaBasicExecutionRole
```

The IAM role is then attached to the Lambda function.

---

# 🔄 CI/CD Pipeline

GitHub Actions is used to automate deployment.

The workflow is located at:

```text
.github/workflows/deploy-layer.yml
```

The pipeline runs when code is pushed to the `main` branch.

It performs the following steps:

```text
Git Push
   │
   ▼
Checkout Repository
   │
   ▼
Configure AWS Credentials
   │
   ▼
Setup Terraform
   │
   ▼
Terraform Init
   │
   ▼
Terraform Validate
   │
   ▼
Terraform Plan
   │
   ▼
Terraform Apply
   │
   ▼
AWS Lambda + Lambda Layer
```

---

# 🔑 GitHub Secrets

The GitHub Actions workflow requires AWS credentials.

The following secrets should be configured in:

```text
GitHub Repository
    ↓
Settings
    ↓
Secrets and variables
    ↓
Actions
```

Create:

```text
AWS_ACCESS_KEY_ID
AWS_SECRET_ACCESS_KEY
```

The workflow accesses them using GitHub Secrets:

```yaml
aws-access-key-id: ${{ secrets.AWS_ACCESS_KEY_ID }}
aws-secret-access-key: ${{ secrets.AWS_SECRET_ACCESS_KEY }}
```

### ⚠️ Security

Never place AWS credentials directly inside the workflow file.

Do not commit:

```text
AWS Access Keys
AWS Secret Keys
.env files
Terraform state files
```

to the repository.

---

# 🚀 Deployment

## 1. Clone the repository

```bash
git clone https://github.com/Prospercash/lambda-layer-project.git
```

Move into the project:

```bash
cd lambda-layer-project
```

---

## 2. Enter the Terraform directory

```bash
cd terraform
```

---

## 3. Initialize Terraform

```bash
terraform init
```

Terraform downloads the required providers and prepares the working directory.

---

## 4. Validate the configuration

```bash
terraform validate
```

Expected result:

```text
Success! The configuration is valid.
```

---

## 5. Review the deployment plan

```bash
terraform plan
```

Terraform will show the resources it intends to create.

---

## 6. Deploy the infrastructure

```bash
terraform apply
```

Enter:

```text
yes
```

Terraform will create the Lambda function, Lambda Layer, IAM role, and required configuration.

---

# 🤖 Automated Deployment

After the initial setup, changes can be deployed through GitHub Actions.

Make a change:

```bash
git add .
```

Commit it:

```bash
git commit -m "Update Lambda Layer"
```

Push it:

```bash
git push origin main
```

GitHub Actions automatically starts the deployment pipeline.

---

# 📤 Terraform Outputs

After deployment, Terraform provides useful information such as:

```text
lambda_function_name
lambda_function_arn
lambda_layer_arn
```

These values can be displayed with:

```bash
terraform output
```

For example:

```bash
terraform output lambda_layer_arn
```

---

# 🧪 Testing the Lambda Function

After deployment, the Lambda function can be tested from the AWS Lambda console.

Use a test event such as:

```json
{}
```

The Lambda function should return a response similar to:

```json
{
  "status": "success",
  "message": "Hello from Lambda Layer!"
}
```

The response is generated by the reusable function stored in the Lambda Layer.

---

# 📦 Benefits of AWS Lambda Layers

## 1. Code Reusability

The same code can be shared between multiple Lambda functions.

```text
              Lambda Layer
             /      |      \
            /       |       \
       Lambda 1  Lambda 2  Lambda 3
```

---

## 2. Reduced Duplication

Common dependencies don't need to be packaged separately into every Lambda function.

---

## 3. Easier Maintenance

When shared utilities need to be updated, a new Layer version can be created.

---

## 4. Separation of Responsibilities

The Lambda function can focus on business logic while the Layer contains reusable libraries and utilities.

```text
Lambda
   ↓
Business Logic

Layer
   ↓
Shared Code / Dependencies
```

---

## 5. Version Management

Lambda Layers support versions.

For example:

```text
python-utils-layer:1
python-utils-layer:2
python-utils-layer:3
```

Different Lambda functions can use appropriate Layer versions.

---

# 💰 Cost Considerations

Creating the Lambda Layer itself does not mean you are running a server continuously.

AWS Lambda uses a serverless execution model, so there is no EC2 instance running for this project.

However, AWS services can incur charges depending on usage and your AWS account configuration.

Always check your AWS billing dashboard and remove resources you no longer need.

To remove the Terraform-managed resources:

```bash
terraform destroy
```

Then confirm:

```text
yes
```

---

# 🧹 Cleanup

When the project is no longer needed:

```bash
cd terraform
terraform destroy
```

This removes the AWS resources managed by this Terraform configuration.

---

# 🔒 Security Best Practices

* Never commit AWS access keys.
* Store credentials in GitHub Secrets.
* Use IAM permissions based on least privilege.
* Do not commit Terraform state files.
* Do not commit `.terraform/`.
* Rotate credentials if they are accidentally exposed.
* Consider using GitHub Actions with AWS OIDC instead of long-lived access keys for production environments.
* Review IAM permissions regularly.

---

# 📚 What I Learned From This Project

This project demonstrates practical experience with:

### AWS

* AWS Lambda
* Lambda Layers
* IAM
* CloudWatch logging
* AWS resource ARNs

### Terraform

* Terraform providers
* Variables
* Resources
* Data sources
* `archive_file`
* Terraform outputs
* Infrastructure as Code

### DevOps

* Git
* GitHub
* GitHub Actions
* CI/CD
* Automated infrastructure deployment

### Python

* Lambda handlers
* Python modules
* Reusable utility functions
* Python package structure

---

# 🎯 Portfolio Description

**AWS Lambda Layer CI/CD Pipeline**

Built a serverless AWS Lambda application with a reusable Python Lambda Layer using Terraform. Implemented IAM permissions and automated infrastructure deployment using GitHub Actions CI/CD. The pipeline validates, plans, and deploys Terraform changes to AWS whenever code is pushed to the main branch.

---

# 👨‍💻 Author

**Braimoh Prosper**

* GitHub: [Prospercash](https://github.com/Prospercash)
* LinkedIn: Braimoh Prosper
* Email: [braimohprosper848@gmail.com](mailto:braimohprosper848@gmail.com)

---

# ⭐ Project Goal

The goal of this project is to demonstrate how reusable Lambda components can be managed as infrastructure and automatically deployed using a modern DevOps workflow:

```text
                    Developer
                       │
                       ▼
                      Git
                       │
                       ▼
                    GitHub
                       │
                       ▼
               GitHub Actions
                       │
                       ▼
                  Terraform
                       │
                       ▼
                      AWS
                 ┌─────┴─────┐
                 ▼           ▼
              Lambda       Layer
                 │           │
                 └─────┬─────┘
                       ▼
                  Application
```

**Infrastructure as Code + CI/CD + Serverless AWS = Automated Deployment**
