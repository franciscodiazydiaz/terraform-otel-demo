# terraform-otel-demo

Terraform code that implements a basic OpenTelemetry (OTEL) agent-gateway architecture.
The architecture components are:
* Lambda function in Go: the OTEL agent is a fork of [opentelemetry-lambda]()
* EC2 instance: the OTEL gateway is the [AWS Distro for OpenTelemetry Collector](https://aws-observability.github.io/aws-otel-collector/docs/developers/debian-deb-demo.html) 

## Requirements

* [Terraform 1.3.x](https://developer.hashicorp.com/terraform/downloads)
* [tfenv](https://github.com/kamatama41/tfenv) (Optional, Terraform version manager)
* [AWS CLI](https://docs.aws.amazon.com/cli/latest/userguide/cli-chap-welcome.html)

## Getting Started

1. Setup AWS credentials

2. Prepare the working directory to execute Terraform

```shell
terraform init
```

3. Create the infrastructure on AWS

```shell
terraform apply
```
