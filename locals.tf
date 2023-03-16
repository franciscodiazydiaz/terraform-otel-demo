locals {
  region = "us-east-1"
  azs    = ["${local.region}a", "${local.region}b", "${local.region}c"]
  name   = "${var.environment}-${var.project}"

  tags = {
    environment = var.environment
    project     = var.project
  }
}
