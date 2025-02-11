terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "5.86.0"
    }
  }
}

provider "aws" {
  # Configuration options
  region = "ap-northeast-2"
}

resource "aws_instance" "example" {
  ami           = "ami-0cee4e6a7532bb297"
  instance_type = "t2.micro"

  tags = {
    Name = "TestInstance"
  }
}

#아래 부분은 인스텃ㄴ스 생성후 화면에 출력되는 내용
output "공인ip주소" {
 value = aws_instance.example.public_ip
}
