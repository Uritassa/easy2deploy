resource "aws_iam_policy" "this" {
  name        = var.policy_name
  description = "Policy to manage network interfaces for EC2 instances"
  policy      = var.policy_document
}


resource "aws_iam_role" "this" {
  name               = var.role_name
  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Effect    = "Allow",
      Principal = {
        Service = "ec2.amazonaws.com"
      },
      Action    = "sts:AssumeRole"
    }]
  })
  tags = var.role_tags
}

resource "aws_iam_role_policy_attachment" "this" {
  policy_arn = aws_iam_policy.this.arn
  role  = aws_iam_role.this.name
}

resource "aws_iam_instance_profile" "this" {
  name = var.instance_profile_name
  role = aws_iam_role.this.name
}

resource "aws_security_group" "this" {
  name        = var.security_group_name
  vpc_id      = var.vpc_id

  dynamic "ingress" {
    for_each = var.ingress_rules
    content {
      from_port   = ingress.value.from_port
      to_port     = ingress.value.to_port
      protocol    = ingress.value.protocol
      cidr_blocks = ingress.value.cidr_blocks
      description = ingress.value.description
    }
  }
  dynamic "egress" {
    for_each = var.egress_rules
    content {
      from_port   = egress.value.from_port
      to_port     = egress.value.to_port
      protocol    = egress.value.protocol
      cidr_blocks = egress.value.cidr_blocks
      description = egress.value.description
    }
  }

  tags = var.security_group_tag
}

resource "aws_launch_template" "this" {
  name                   = var.launch_template_name
  update_default_version = true
  instance_type          = var.instance_type
  key_name               = var.key_name
  image_id               = var.ami
  user_data              = base64encode(var.user_data)
  instance_initiated_shutdown_behavior = "stop"
  iam_instance_profile {
    name = aws_iam_instance_profile.this.name
  }

  monitoring {
    enabled = true
  }

  network_interfaces {
    associate_public_ip_address = true
    security_groups             = [aws_security_group.this.id]
  }

  tag_specifications {
    resource_type = "instance"
    tags = var.launch_template_tags
  }

  metadata_options {
    http_endpoint               = "enabled"
    http_put_response_hop_limit = 1
    http_tokens                 = "optional"
    instance_metadata_tags      = "enabled"
  }

}
resource "aws_autoscaling_group" "this" {
  vpc_zone_identifier = var.public_subnet_ids
  desired_capacity    = var.desired_capacity
  max_size            = var.max_size
  min_size            = var.min_size

  launch_template {
    id      = aws_launch_template.this.id
    version = "$Latest"
  }
}

resource "aws_eip" "this" {
  count = var.create_eip ? 1 : 0
  domain = "vpc"

  tags = merge(
    var.eip_tags,
    {
      Name = "${var.launch_template_name}-eip"
    },
  )
}

