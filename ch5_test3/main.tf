# 간단한 웹서버 ubuntu 활용 
# 8080/tcp
#  키페어 넣고 aws 에 키 생성. 우분투 이미지 
resource "aws_instance" "example" {
  ami           = "ami-0077297a838d6761d"
  instance_type = "t2.micro"
  vpc_security_group_ids = [aws_security_group.instance.id]
  key_name = aws_key_pair.testkey.key_name 
} 
resource "aws_security_group" "instance" {
  name = "terraform-example-instance"

  ingress {
	from_port = 8080 
	to_port = 8080
	protocol = "tcp"
	cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
        from_port = 22
        to_port = 22
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
 
 resource "aws_key_pair" "testkey" {
  key_name   = "testkey"
  public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDH0dXo8egK1K0NvnpHNWDq1yiOGoRF9h4ik1rQV1VJobW65g0XEoACfXbAZJtNuExUR4kmGqm0/x/am5A9umeyzfBHGC2zrRrseOy0pQb4YeuhZo4PNJuFY9c62HYbPa8gkf2Zkd25kRkqRlY/Q+u7yTnYqeV8Vi31FbvYL7hFdlFrFHTY3bEpELap0+K5U9b7xDaJ0zq9QHu+CfxMba10IKEmCkB4HWYEM5isaS8MPwWLt4z4n+uplLPGHu+bElruE9ehQDE+kbd+Lc9zW3tX61aDKtzrtEoHbdC4v72DHAzGrRVXvBmmU5D1NFHDjxjlFJMzJCE6uDw8g3qVuLYfsgBZCVWVV2OsXvl3ob0Y2RpBPtTaIMqxEuMRf5+rOqQ/E/MXK5Erqot+Pcf5BezI6ZkmiInAZZA/nRoaI+pIz91E6ndI9YEg6oSuF935oQEjz1hPBBSjhebjP8moJxJ/Vr0XAIbXv7k+Z1upgeJPP9wNdTKVgC3ERzE/RABSH08= root@localhost.localdomain"
}
