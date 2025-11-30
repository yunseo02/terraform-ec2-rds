variable "aws_region" {
  description = "AWS 리전"
  type        = string
  default     = "ap-northeast-2"  # 서울 리전
}

variable "project_name" {
  description = "프로젝트 이름 (리소스 태그에 사용)"
  type        = string
  default     = "spring-app"
}

variable "ec2_ami" {
  description = "EC2 AMI ID (Amazon Linux 2023)"
  type        = string
  default     = "ami-062cf18d655c0b1e8"  # ap-northeast-2의 Amazon Linux 2023
}

variable "ec2_instance_type" {
  description = "EC2 인스턴스 타입"
  type        = string
  default     = "t3.micro"
}

variable "ec2_key_name" {
  description = "EC2 SSH 키페어 이름"
  type        = string
  # 실제 사용하시는 키페어 이름으로 변경하세요
}

variable "rds_instance_class" {
  description = "RDS 인스턴스 클래스"
  type        = string
  default     = "db.t3.micro"
}

variable "db_name" {
  description = "데이터베이스 이름"
  type        = string
  default     = "springdb"
}

variable "db_username" {
  description = "데이터베이스 마스터 사용자명"
  type        = string
  default     = "admin"
}

variable "db_password" {
  description = "데이터베이스 마스터 비밀번호"
  type        = string
  sensitive   = true
  # terraform.tfvars 파일에서 설정하세요
}