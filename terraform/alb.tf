# APPLICATION LOAD BALANCER

resource "aws_lb" "app" {
  name               = "andrews-legacy-alb"
  internal           = false
  load_balancer_type = "application"

  security_groups = [
    aws_security_group.alb_sg.id
  ]

  subnets = [
    aws_subnet.public_1.id,
    aws_subnet.public_2.id
  ]

  tags = {
    Name = "${var.project_name}-alb"
  }
}


# TARGET GROUP

resource "aws_lb_target_group" "wordpress" {
  name     = "andrews-wordpress-tg"
  port     = 80
  protocol = "HTTP"
  vpc_id   = aws_vpc.andrews_vpc.id

  health_check {
    enabled             = true
    path                = "/"
    port                = "traffic-port"
    protocol            = "HTTP"
    healthy_threshold   = 2
    unhealthy_threshold = 2
    timeout             = 5
    interval            = 30
    matcher             = "200-399"
  }

  tags = {
    Name = "${var.project_name}-wordpress-tg"
  }
}


# TARGET GROUP ATTACHMENT

resource "aws_lb_target_group_attachment" "wordpress" {
  target_group_arn = aws_lb_target_group.wordpress.arn
  target_id        = aws_instance.web.id
  port             = 80
}



# HTTP LISTENER

resource "aws_lb_listener" "http" {
  load_balancer_arn = aws_lb.app.arn

  port     = 80
  protocol = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.wordpress.arn
  }
}