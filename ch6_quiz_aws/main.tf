# 새로운 VPC 생성
resource "aws_vpc" "new_vpc" {
  cidr_block = "172.18.0.0/16"

  tags = {
    Name = "new_vpc"
  }
}



# 퍼블릭 서브넷 생성
resource "aws_subnet" "public" {
  vpc_id                  = aws_vpc.new_vpc.id
  cidr_block              = "172.18.1.0/24"
  map_public_ip_on_launch = true
  availability_zone       = "ap-northeast-2a"
}
# 프라이빗 서브넷 생성
resource "aws_subnet" "private" {
  vpc_id                  = aws_vpc.new_vpc.id
}

# 인터넷 게이트웨이 생성 (새로운 VPC에 연결)
resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.new_vpc.id
}

# 탄력적 IP (EIP) 생성 (NAT용)
resource "aws_eip" "nat" {
  domain = "vpc"
}

# NAT Gateway 생성
resource "aws_nat_gateway" "nat" {
  allocation_id = aws_eip.nat.id
  subnet_id     = aws_subnet.public.id
  depends_on    = [aws_internet_gateway.gw]
}

# 퍼블릭 서브넷용 라우트 테이블
# 기본적으로 local에 대한 라우팅 테이블은 만들어 진다. 
# 그래서 internet g/w 에 대한 테이블 정보만 추가로 기입해주면 된다. 
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.new_vpc.id
  cidr_block              = "172.18.2.0/24"
  availability_zone       = "ap-northeast-2a"
}

resource "aws_route" "public_internet_access" {
  route_table_id         = aws_route_table.public.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.gw.id
}

resource "aws_route_table_association" "public" {
  subnet_id      = aws_subnet.public.id
  route_table_id = aws_route_table.public.id
}


# 탄력적 IP (EIP) 생성 (NAT용)
resource "aws_eip" "nat" {
  domain = "vpc"
}

# NAT Gateway 생성
resource "aws_nat_gateway" "nat" {
  allocation_id = aws_eip.nat.id
  subnet_id     = aws_subnet.public.id
  depends_on    = [aws_internet_gateway.gw]
}

# 프라이빗 서브넷용 라우트 테이블 (NAT 경유)
resource "aws_route_table" "private" {
  vpc_id = aws_vpc.new_vpc.id
}

resource "aws_route" "private_nat_access" {
  route_table_id         = aws_route_table.private.id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.nat.id
}

resource "aws_route_table_association" "private" {
  subnet_id      = aws_subnet.private.id
  route_table_id = aws_route_table.private.id
}


# 보안 그룹 생성
resource "aws_security_group" "instance_sg" {
  vpc_id = aws_vpc.new_vpc.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# Auto Scaling Launch Template
resource "aws_launch_template" "app" {
  name          = "asg-launch-template"
  image_id      = "ami-0cee4e6a7532bb297"  # 적절한 AMI ID 입력
  instance_type = "t3.micro"
  key_name      = "testkey"             # 적절한 key 이름 입력
  network_interfaces {
    associate_public_ip_address = false
    subnet_id                   = aws_subnet.private.id
    security_groups             = [aws_security_group.instance_sg.id]
  }
}

# Auto Scaling Group
resource "aws_autoscaling_group" "asg" {
  desired_capacity     = 2
  min_size            = 1
  max_size            = 3
  vpc_zone_identifier = [aws_subnet.private.id]

  launch_template {
    id      = aws_launch_template.app.id
    version = "$Latest"
  }
}

