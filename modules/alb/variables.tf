output "alb_arn" {
  value = aws_lb.alb.arn
}

output "http_listener_arn" {
  value = aws_lb_listener.http.arn
}

output "https_listener_arn" {
  value = aws_lb_listener.https.arn
}

output "target_group_arn" {
  value = aws_lb_target_group.tg.arn
}

