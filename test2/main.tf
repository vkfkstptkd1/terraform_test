resource "openstack_compute_instance_v2" "basic-instance01" {
  name            = "basic-instance01"
  image_id        = "d441320f-d026-44d3-b488-2979dc13c86b"
  flavor_id       = "1"
  key_pair        = "lab-openstack-0206"
  security_groups = ["permit-jenkins"]

  network {
    name = "webnet"
  }
}

# 공인 IP 출력 (Floating IP를 수동으로 설정해야 할 수 있음)
resource "openstack_networking_floatingip_v2" "floating_ip" {
  pool = "sharednet1"  # Public Network 이름
}

resource "openstack_compute_floatingip_associate_v2" "fip_association" {
  floating_ip = openstack_networking_floatingip_v2.floating_ip.address
  instance_id = openstack_compute_instance_v2.basic-instance01.id
  fixed_ip = openstack_compute_instance_v2.basic-instance01.network.0.fixed_ip_v4
}



