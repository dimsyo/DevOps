output "alb_dns_name" {
  value       = aws_lb.main.dns_name
  description = "Public DNS Name of the Application Load Balancer"
}

output "alb_arn" {
  value       = aws_lb.main.arn
  description = "ARN of the Application Load Balancer"
}

output "target_group_arn" {
  value       = aws_lb_target_group.main.arn
  description = "ARN of the ALB Target Group"
}
