
# EC2 OUTPUTS

output "ec2_instance_id" {
  description = "EC2 application server instance ID"
  value       = aws_instance.web.id
}

output "ec2_public_ip" {
  description = "EC2 application server public IP"
  value       = aws_instance.web.public_ip
}

output "ec2_private_ip" {
  description = "EC2 application server private IP"
  value       = aws_instance.web.private_ip
}


# ALB OUTPUT


output "alb_dns_name" {
  description = "Application Load Balancer DNS name"
  value       = aws_lb.app.dns_name
}


# RDS OUTPUT


output "rds_endpoint" {
  description = "RDS MySQL endpoint"
  value       = aws_db_instance.mysql.address
}

# S3 OUTPUT


output "backup_bucket_name" {
  description = "S3 migration backup bucket"
  value       = aws_s3_bucket.backups.bucket
}