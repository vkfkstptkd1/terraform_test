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

output "addr" {
	value = "${openstack_compute_instance_v2.cirros[*].network.0.fixed_ip_v4}"
}
