resource "aws_lb_listener" "http" {
  load_balancer_arn = aws_lb.app_alb.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type = "forward"
    forward {
      target_group {
        arn    = aws_lb_target_group.v1.arn
        weight = 10
      }
      target_group {
        arn    = aws_lb_target_group.v2.arn
        weight = 90
      }
      stickiness {
        enabled  = false
        duration = 1
      }
    }
  }
}

resource "aws_lb_listener" "https" {
  load_balancer_arn = aws_lb.app_alb.arn
  port              = 443
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-2016-08"
  certificate_arn   = var.acm_certificate_arn # <-- pass this in via variable

  default_action {
    type = "forward"
    forward {
      target_group {
        arn    = aws_lb_target_group.v1.arn
        weight = 10
      }
      target_group {
        arn    = aws_lb_target_group.v2.arn
        weight = 90
      }
      stickiness {
        enabled  = false
        duration = 1
      }
    }
  }
}
