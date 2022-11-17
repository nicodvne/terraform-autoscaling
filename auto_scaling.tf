resource "aws_launch_template" "instance_template" {
  name_prefix   = "instance_template"
  image_id      = "${var.amiId}"
  instance_type = "t2.micro"
  vpc_security_group_ids = [aws_security_group.autoscalling_security_group.id]
  
  tag_specifications {
    resource_type = "instance"

    tags = {
        Name = "${var.vpc_name}-lb-instances-${var.aws_region}"
        Environment = var.environment
        Owner = "nico.dvne@gmail.com"
    }
  }
}

resource "aws_autoscaling_group" "autoscaling_group" {
  vpc_zone_identifier = [ for subnet in module.discovery.private_subnets : subnet]
  desired_capacity   = 1
  max_size           = 3
  min_size           = 1
  target_group_arns = [aws_lb_target_group.lb_target_group_http.arn, aws_lb_target_group.target_group_netstat.arn]

  health_check_type = "ELB"
  health_check_grace_period = 300

  launch_template {
    id      = aws_launch_template.instance_template.id
    version = "$Latest"
  }
}

resource "aws_autoscaling_policy" "grow-as-policy" {
  name                   = "Add an instance"
  scaling_adjustment     = 1
  adjustment_type        = "ChangeInCapacity"
  cooldown               = 20
  autoscaling_group_name = aws_autoscaling_group.autoscaling_group.name
}

resource "aws_autoscaling_policy" "less-as-policy" {
  name                   = "Delete an instance"
  scaling_adjustment     = -1
  adjustment_type        = "ChangeInCapacity"
  cooldown               = 20
  autoscaling_group_name = aws_autoscaling_group.autoscaling_group.name
}