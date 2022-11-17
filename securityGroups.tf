resource "aws_security_group" "loadbalancing_security_group" {
  name        = "LoadBalancing"
  description = "LoadBalancer security group"
  vpc_id      = module.discovery.vpc_id

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.vpc_name}-loadbalancing-security-group-${var.aws_region}"
    Environment = var.environment
    Owner = "nico.dvne@gmail.com"
  }
}

//Add ingress rule allow 80 call
resource "aws_security_group_rule" "lb_allow_http" {
  type              = "ingress"
  from_port         = 80
  to_port           = 80
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.loadbalancing_security_group.id
}

//Add ingress rule allow 80 call
resource "aws_security_group_rule" "lb_allow_netstat" {
  type              = "ingress"
  from_port         = 19999
  to_port           = 19999
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.loadbalancing_security_group.id
}


resource "aws_security_group" "autoscalling_security_group" {
  name        = "Autoscalling security"
  description = "Autoscalling security group"
  vpc_id      = module.discovery.vpc_id

  //Only allow exit on 8080
  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.vpc_name}-autoscalling-security-group-${var.aws_region}"
    Environment = var.environment
    Owner = "nico.dvne@gmail.com"
  }
}

//Add ingress rule allow 80 call
resource "aws_security_group_rule" "lb_allow_8080" {
  type              = "ingress"
  from_port         = 8080
  to_port           = 8080
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.autoscalling_security_group.id
}

resource "aws_security_group_rule" "instance_allow_netstat" {
  type              = "ingress"
  from_port         = 19999
  to_port           = 19999
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.autoscalling_security_group.id
}