output "ec2_public_ip" {
  description = "EC2 인스턴스 퍼블릭 IP"
  value       = aws_instance.app_server.public_ip
}

output "ec2_public_dns" {
  description = "EC2 인스턴스 퍼블릭 DNS"
  value       = aws_instance.app_server.public_dns
}

output "rds_endpoint" {
  description = "RDS 엔드포인트"
  value       = aws_db_instance.main.endpoint
}

output "rds_connection_string" {
  description = "스프링 부트 application.properties에 사용할 DB 연결 문자열"
  value       = "jdbc:mysql://${aws_db_instance.main.endpoint}/${var.db_name}"
  sensitive   = false
}

output "db_username" {
  description = "데이터베이스 사용자명"
  value       = var.db_username
}

output "ssh_command" {
  description = "EC2에 SSH 접속 명령어"
  value       = "ssh -i ~/.ssh/${var.ec2_key_name}.pem ubuntu@${aws_instance.app_server.public_ip}"
}