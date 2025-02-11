
# 공인 IP 출력
output "public_ip" {
  value = openstack_networking_floatingip_v2.floating_ip.address
}
# 사설 IP 출력
output "private_ip" {
  value = openstack_compute_instance_v2.basic-instance01.network[0].fixed_ip_v4
}


