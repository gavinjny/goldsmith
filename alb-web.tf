resource "aws_lb" "app_alb" {
  name               = "alb-web-demo"
  internal           = false
  load_balancer_type = "application"
  security_groups    = var.security_group
  subnets            = var.aws_vpc_zone_identifier
}

resource "aws_lb_target_group" "v1" {
  name     = "tg-v1"
  port     = 80
  protocol = "HTTP"
  vpc_id   = var.vpc
}

resource "aws_lb_target_group" "v2" {
  name     = "tg-v2"
  port     = 80
  protocol = "HTTP"
  vpc_id   = var.vpc
}
resource "aws_lb_target_group_attachment" "tg_v1_attach" {
  count            = 1
  target_group_arn = aws_lb_target_group.v1.arn
  target_id        = aws_instance.web[0].id
  port             = 80
}

resource "aws_lb_target_group_attachment" "tg_v2_attach" {
  count            = 1
  target_group_arn = aws_lb_target_group.v2.arn
  target_id        = aws_instance.web[1].id
  port             = 80
}

resource "aws_lb_listener" "http" {
  load_balancer_arn = aws_lb.app_alb.arn
  port              = 80
  protocol          = "HTTP"
  default_action {
    type = "forward"
    forward {
      target_group {
        arn    = aws_lb_target_group.v1.arn
        weight = 90
      }
      target_group {
        arn    = aws_lb_target_group.v2.arn
        weight = 10
      }
      stickiness {
        enabled  = false
        duration = 1
      }
    }
  }
}
