output "asg_name" {
  value       = aws_autoscaling_group.app.name
  description = "Name of the Auto Scaling Group"
}

output "asg_arn" {
  value       = aws_autoscaling_group.app.arn
  description = "ARN of the Auto Scaling Group"
}

output "launch_template_id" {
  value       = aws_launch_template.app.id
  description = "ID of the Launch Template"
}
