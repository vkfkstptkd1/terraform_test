
#아래 부분은 인스텃ㄴ스 생성후 화면에 출력되는 내용
output "공인ip주소" {
 value = aws_instance.example.public_ip
}
