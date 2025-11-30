# AWS Terraform 인프라 자동화 가이드

## 프로젝트 개요

스프링 부트 애플리케이션 배포를 위한 AWS 인프라를 Terraform으로 자동화하는 프로젝트입니다.

### 생성되는 리소스

- VPC 및 서브넷 (퍼블릭 1개, 프라이빗 2개)
- 인터넷 게이트웨이
- 보안 그룹 (EC2용, RDS용)
- EC2 인스턴스 (스프링 부트 실행)
- RDS MySQL 인스턴스 (데이터베이스)

## 사전 준비

### 1. 필수 도구 설치

- AWS CLI 설치 및 설정 완료
- Terraform 설치 완료

### 2. AWS 설정

**AWS CLI 설정:**
```bash
aws configure
```

입력 정보:
- AWS Access Key ID
- AWS Secret Access Key
- Default region: ap-northeast-2 (서울)
- Default output format: json

**EC2 키페어 생성:**

1. AWS 콘솔 접속
2. EC2 → 네트워크 및 보안 → 키 페어
3. "키 페어 생성" 클릭
4. 이름 입력
5. 키 페어 유형: RSA
6. 프라이빗 키 파일 형식: .pem
7. 다운로드된 .pem 파일 저장

**키 파일 권한 설정:**
```bash
mkdir -p ~/.ssh
mv ~/Downloads/your-key.pem ~/.ssh/
chmod 400 ~/.ssh/your-key.pem
```

## Terraform 파일 구조

```
aws-terraform/
├── main.tf                    # 메인 인프라 정의
├── variables.tf               # 변수 정의
├── outputs.tf                 # 출력 값 정의
├── terraform.tfvars          # 실제 변수 값 (Git에 올리지 말 것!)
└── terraform.tfvars.example  # 변수 값 예제
```

## 설정 및 실행

### 1. terraform.tfvars 파일 생성

```bash
cp terraform.tfvars.example terraform.tfvars
```

### 2. terraform.tfvars 파일 수정

```hcl
# EC2 키페어 이름 (.pem 확장자 제외!)
ec2_key_name = "your-key"

# 데이터베이스 비밀번호 (최소 8자, 대소문자, 숫자 포함)
db_password = "YourSecurePassword123!"

# 선택사항: 프로젝트 이름 변경
# project_name = "my-spring-app"
```

### 3. Terraform 초기화

```bash
terraform init
```

처음 한 번만 실행하면 됩니다. AWS 프로바이더 및 플러그인을 다운로드합니다.

### 4. 실행 계획 확인

```bash
terraform plan
```

어떤 리소스가 생성될지 미리 확인합니다. 에러가 있으면 여기서 확인 가능합니다.

### 5. 인프라 생성

```bash
terraform apply
```

`yes` 입력 후 5-10분 정도 기다리면 완료됩니다.

### 6. 생성된 정보 확인

```bash
terraform output
```

출력 예시:
```
db_username = "admin"
ec2_public_ip = "43.202.62.241"
rds_endpoint = "spring-app-db.xxx.ap-northeast-2.rds.amazonaws.com:3306"
rds_connection_string = "jdbc:mysql://spring-app-db.xxx.ap-northeast-2.rds.amazonaws.com:3306/springdb"
ssh_command = "ssh -i ~/.ssh/hufs-cheongwon-key.pem ubuntu@43.202.62.241"
```

## EC2 접속 및 사용

### SSH 접속

```bash
ssh -i ~/.ssh/your-key.pem ubuntu@EC2_PUBLIC_IP
```

**주의:** AMI에 따라 사용자 이름이 다를 수 있습니다.
- Amazon Linux: `ec2-user`
- Ubuntu: `ubuntu`

### Java 설치 (Ubuntu 기준)

```bash
sudo apt update
sudo apt install -y openjdk-17-jdk
```

### 스프링 부트 애플리케이션 배포

```bash
# JAR 파일 업로드
scp -i ~/.ssh/your-key.pem your-app.jar ubuntu@EC2_IP:~/

# 실행
java -jar your-app.jar
```

## RDS 접속 방법

### 방법 1: EC2에서 CLI로 접속

**1단계: EC2 접속**
```bash
ssh -i ~/.ssh/your-key.pem ubuntu@EC2_PUBLIC_IP
```

**2단계: MySQL 클라이언트 설치**
```bash
sudo apt update
sudo apt install -y mysql-client
```

**3단계: RDS 접속**
```bash
mysql -h RDS_ENDPOINT -u admin -p
```

비밀번호 입력 후 사용:
```sql
SHOW DATABASES;
USE springdb;
SHOW TABLES;
```

### 방법 2: 로컬에서 GUI 도구로 접속 (SSH 터널링)

**DataGrip / IntelliJ IDEA 설정:**

1. 새 데이터 소스 추가 → MySQL
2. General 탭:
   - Host: RDS 엔드포인트
   - Port: 3306
   - User: admin
   - Password: 설정한 비밀번호
   - Database: springdb

3. SSH/SSL 탭:
   - Use SSH tunnel 체크
   - Host: EC2
