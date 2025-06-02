resource "aws_lb_listener" "http" {
  load_balancer_arn = aws_lb.app_alb.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type = "forward"
    forward {
      target_group {
        arn    = aws_lb_target_group.v1.arn
        weight = 50
      }
      target_group {
        arn    = aws_lb_target_group.v2.arn
        weight = 50
      }
      stickiness {
        enabled  = false
        duration = 1
      }
    }
  }
}
