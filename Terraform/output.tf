output "instance_public_and_private_ips" {
  value = {
    for instance, inst in aws_instance.servers :instance => {
      public_ip = inst.public_ip
      private_ip = inst.private_ip
    }
  }
  description = "Public and Private IP addresses of the EC2 instances"
}

output "sns_topic_arn" {
  value = aws_sns_topic.sns_topic.arn
  description = "The ARN of the SNS topic for alerts"
}