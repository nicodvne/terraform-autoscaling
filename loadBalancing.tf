resource "aws_lb" "load_balander" {
  name               = "${var.vpc_name}-load-balancer-${var.aws_region}"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.loadbalancing_security_group.id]
  subnets            = [for subnet in module.discovery.public_subnets : subnet]

  enable_deletion_protection = true

  tags = {
    Name = "${var.vpc_name}-load-balancer-${var.aws_region}"
    Environment = var.environment
    Owner = "nico.dvne@gmail.com"
  }
}

resource "aws_lb_listener" "listener_front_end" {
  load_balancer_arn = aws_lb.load_balander.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.lb_target_group_http.arn
  }
}

resource "aws_lb_listener" "listener_net_stat" {
  load_balancer_arn = aws_lb.load_balander.arn
  port              = "19999"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.target_group_netstat.arn
  }
}

