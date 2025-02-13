resource "openstack_compute_instance_v2" "cirros" {
	#오픈스택에서 name 은 필수사항이면서 유니크 해야한다. aws는 정 반대 
	name		= "cirros_${count.index}"
	flavor_id	= "1"
	security_groups = ["default", "permit-ssh-web"]
	count		= 2
	
	block_device {
	  uuid = "d441320f-d026-44d3-b488-2979dc13c86b"
	  source_type = "image"
	  volume_size = 3 # 3GB
	  boot_index = 0 # 숫자가 작을 수록 우선한다. 
	  destination_type = "volume" #원격지에서 볼륨으로 활용 하겠다. 
	  delete_on_termination = true # 인스턴스 지울 때 이 볼륨도 같이 지울래 ? true :  지운다는 말 
	
	}

	network {
	  name = "webnet"
	}

}


#quiz floating ip 추가 
resource "openstack_networking_floatingip_v2" "floatIP" {
	pool = "sharednet1"
	count = 2
}

resource "openstack_compute_floatingip_associate_v2" "floatIP" {
	count = 2
	floating_ip = "${openstack_networking_floatingip_v2.floatIP[count.index].address}"
	instance_id = "${openstack_compute_instance_v2.cirros[count.index].id}"
}
output "instance_names_and_ips" {
  value = [for idx in range(length(openstack_compute_instance_v2.cirros)) :
    "${openstack_compute_instance_v2.cirros[idx].name}:${openstack_networking_floatingip_v2.floatIP[idx].address}"
  ]
}

