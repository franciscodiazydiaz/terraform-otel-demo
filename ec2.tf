module "otel_instance" {
  source  = "terraform-aws-modules/ec2-instance/aws"
  version = "~> 4.3"

  name = local.name

  ami           = data.aws_ami.ubuntu.id
  instance_type = "t3.small"

  # No sshkey, use SSM instead
  key_name               = ""
  monitoring             = true
  vpc_security_group_ids = [aws_security_group.otel_instance.id]
  user_data              = data.cloudinit_config.otel_instance.rendered

  create_iam_instance_profile = true

  tags = local.tags
}

#
# User Data
#
data "cloudinit_config" "otel_instance" {
  gzip          = false
  base64_encode = false

  # AWS cli
  part {
    content_type = "text/x-shellscript"
    content      = file("templates/userdata_awscli.tftpl")
  }

  # ADOTCollector
  part {
    content_type = "text/x-shellscript"
    content      = file("templates/userdata_adotcollector.tftpl")
  }
}

#
# AMI: Ubuntu 22.04
#
data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"]
  }

  filter {
    name   = "root-device-type"
    values = ["ebs"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"]
}

#
# Security Groups & Rules
#
resource "aws_security_group" "otel_instance" {
  name        = local.name
  description = "SG for the OTEL instance"
  vpc_id      = module.vpc.vpc_id

  tags = local.tags
}

resource "aws_security_group_rule" "otel_instance_egress_tcp_wildcard" {
  security_group_id = aws_security_group.otel_instance.id
  description       = "Allow egress all TCP traffic"
  type              = "egress"
  from_port         = 0
  to_port           = 65535
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
}

#
# IAM Policies
#
resource "aws_iam_role_policy_attachment" "ssm_managed_policy" {
  role       = module.otel_instance.iam_role_name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}
