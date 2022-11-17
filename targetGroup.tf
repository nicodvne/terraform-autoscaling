resource "aws_lb_target_group" "lb_target_group_http" {
  name     = "lb-target-group"
  port     = 8080
  protocol = "HTTP"
  vpc_id   = module.discovery.vpc_id
}


resource "aws_lb_target_group" "target_group_netstat" {
  name     = "lb-target-group-netstat"
  port     = 19999
  protocol = "HTTP"
  vpc_id   = module.discovery.vpc_id
}

