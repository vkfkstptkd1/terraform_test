# 간단한 웹서버 (busybox 사용하여!!)
# 8080/tcp
# 지금은 ssh 연결을 하지 않을 계획이지만 내일 오전에 키페어 넣을 예정 
resource "aws_instance" "example" {
  ami           = "ami-0077297a838d6761d"
  instance_type = "t2.micro"
  vpc_security_group_ids = [aws_security_group.instance.id]
  
  user_data = <<-EOF
 		#!bin/bash
		echo "hello, aws" > index.html
		nohup busybox httpd -f -p 8080 & # 세션이 끊겨도 실행 
  	        EOF
} 
resource "aws_security_group" "instance" {
  name = "terraform-example-instance"

  ingress {
	from_port = 8080 
	to_port = 8080
	protocol = "tcp"
	cidr_blocks = ["0.0.0.0/0"]
  }

   #icmp는 port로 접근하는게 아니다.
  ingress {
	from_port = -1 
	to_port = -1
	protocol = "icmp"
	cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
	from_port = 0
	to_port = 0
	protocol = "-1"
	cidr_blocks = ["0.0.0.0/0"]
	ipv6_cidr_blocks = ["::/0"]
  }
 }
 
 
