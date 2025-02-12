output "공인ip주소" {
  value = data.aws_instances.example_instance.public_ips
}
