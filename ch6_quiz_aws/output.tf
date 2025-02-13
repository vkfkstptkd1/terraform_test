output "instance_public_ips" {
  description = "ASG 이용하여 확인된 공인주소들"
  value       = data.aws_instances.example_instance.public_ips
}


output "cls_dns_name" {
  description = "CLB 도메인 이름"
  value = aws_elb.example.dns_name
}

