resource "aws_instance" "server" {
	count = 2
	
	# 필수값 
	ami = "ami-0cee4e6a7532bb297"
	instance_type = "t3.micro" 

	#이 아래부터 필수값 아님. 
	tags = {
	  Name = "server-${count.index}"
	}
}


# output은 value의 값을 담아야 한다. 
output "server_name" {
#	value = aws_instance.server.${count.index}.tags.Name
	value = aws_instance.server.*.tags.Name
}
