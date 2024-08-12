# AWS Cloud Resume Challenge - by Sevaghi

## Table of Contents

- [The Challenge](#the-challenge)
- [Architecture](#architecture)
- [AWS Services Used](#aws-services-used)
- [Frontend](#frontend)
- [Backend](#backend)
- [IaC whith Terraform](#iac-with-terraform)

## The Challenge

**Official Website of the Challenge**: [The CLoud Resume Challenge](https://cloudresumechallenge.dev)

**My Own Resume**: [Sevaghi Web Portfolio](https://sevaghiga.com)

## Architecture

![sevaghi-crc-architecture](https://github.com/sevaghi/aws-diagrams/blob/34dffbe05d1e728e302563a9fd81e8a4935e395d/aws-crc-diagram.png)

## AWS Services Used

Frontend:
- Amazon S3
- Certificate Manager (ACM)
- Route 53
- Amazon CloudFront

Backend:
- DynamoDB
- Lambda
- API Gateway

## Frontend
**1. Website**
- An static website has been created based on the midudev's minimalist-portfolio-json projecto which uses Astro (https://github.com/midudev/minimalist-portfolio-json)
- A simple visit counter has been added to the website using Javascript to interact with the API Gateway each time a user visits the site and return the total number of users

**2. Amazon S3**
- Used to host the static website files
- Configured with website hosting, versioning, and appropriate bucket policies to allow access from CloudFront

**2. AWS Certificate Manager (ACM)**
- Manages the SSL/TLS certificate for the custom domain, ensuring secure HTTPS connections

**3. Route 53**
- Manages the DNS records for the custom domain, pointing to the CloudFront distribution for global accessibility

**4. Amazon CloudFront**
- Distributes the website content globally, providing low-latency access and HTTPS support
- Configured with caching policies to optimize content delivery
- Utilizes a custom error response to handle single-page application routing

## Backend
**1. Amazon DynamoDB**
- A table is created to store the visit counter data
- An initial item is added to the table to represent the visit count
- The table is configured in PAY_PER_REQUEST mode to scale automatically with traffic

**2. AWS Lambda**
- A Python-based Lambda function (portfolio-web-counter) is deployed to process requests for incrementing the visit counter
- The Lambda function is granted IAM permissions to read/write from DynamoDB

**3. Amazon API Gateway**
- Exposes a REST API to interact with the Lambda function
- Configured with GET and OPTIONS methods for incrementing the visit counter and handling CORS requests

**4. Amazon ClodWatch**
- Integrated with API Gateway to log and monitor API requests and responses
- Logs are stored in a CloudWatch log group for system monitoring and debugging

## IaC with Terraform
- The project is defined using Terraform and AWS as the primary provider
- Separate Terraform state files are managed using S3 for both frontend and backend configurations (remote state)
- The project utilizes two AWS regions: 'eu-west-1' for the main resources and 'us-east-1' for ACM Certificates