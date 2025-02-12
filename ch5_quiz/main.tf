resource "aws_launch_configuration" "example" {
  image_id           = "ami-0cee4e6a7532bb297"
  instance_type = "t3.micro"
  security_groups = [aws_security_group.instance.id]
  key_name = aws_key_pair.testkey.key_name
  user_data = <<-EOF
                 #!/bin/bash
                 echo "hello, aws" > index.html
                 sudo yum -y install httpd
                 sudo sed -c '^/Listen/c\Listen ${var.server_port}' /etc/httpd/conf/httpd.conf
                 sudo systemctl restart httpd
                 EOF
  lifecycle {
    create_before_destroy = true # 새로운 인스턴스 생성 후 삭제 
    # 삭제방지 
    # prevent_destroy = true
    # 특정 요소 변경 시 재생성 
    # 
  }

}


# data:  고정되어있는 값을 가지고와서 내부적으로 쓰고싶을 때 가져옴. 변수와 비슷하지만다르다. 이미 만들어져있는 데이터 값을 가져와서 쓰는 것이다.
data "aws_vpc" "default" { 
  default = true
}

# default vpc에 있는 서브넷들만 필터링 해서 가져와줘 
data "aws_subnets" "default" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.default.id]  # ✅ 필터로 변경
  }
}



resource "aws_autoscaling_group" "example" {
  launch_configuration = aws_launch_configuration.example.name
  vpc_zone_identifier = data.aws_subnets.default.ids
  min_size = 2
  max_size = 4

  tag {
    key = "Name"
    value = "terraform-asg-example"
    propagate_at_launch = true
  }
}

# 공인 ip 출력을 위함. 
# instatnce 들 중에 tag가 terraform-asg-example인 애들만 골라줘 !! >> aws_autoscaling_group에 정의한 tag값 
data "aws_instances" "example_instance" {
  filter {
    name = "tag:Name"
    values = ["terraform-asg-example"]
  }
}


resource "aws_security_group" "instance" {
  name = "terraform-example-instance"

  ingress {
    from_port = var.server_port
    to_port = var.server_port
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port = -1
    to_port = -1
    protocol = "icmp"
    cidr_blocks = ["0.0.0.0/0"]

  }


  ingress {
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]

  }

  egress{
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

}

# key-pair 등록하기
resource "aws_key_pair" "testkey" {
  key_name   = "testkey"
  public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQClFRb6eNfPiH+2plNTYwEsLC2clNxcFqVTYWQITfA5WEXwRzlMFGtERy3onvP7DByL/q1meVPjZr3Wi7+IIQvgw9r0WBcUzG2d5b1ENA7OkbuusplW+a2WtgGAzcKc06QPXJp1FkwnmTPFdeHmc8ooX14tZE2WyHg1T0JX4NC1PH/134ip5zE8TlDIBR+TQGCvOvjDRnnU9PS4YKVRAblirSQVKbfQ547t9OJl+tQpZooTHi5iLVlXeunb4LGdvliUMLHAgCd8lmzCYcEEEvq7vLA5B23T3kmraKAJPsolEggzXQ5rLkS9DCIrVIvvuY/bO0vrqOyanSI6r/lBU+jPfvteKRXAQ01fFuT93QseuVHvwWRhh1UfPuet4NdkgTC2nPNOUND2SrqKrVR5vQm5CePy3P0SeJqySs2ozo9Edte6ckYAikiPXT0AdrRAVpuAry6VNPaC1EaWEPRyqqWjzrcY3CBcyYD1Bmh8y9Z0ZOpFcYKnm8eQD90a4M2Tzf0= user1@localhost.localdomain"
}

