resource "openstack_compute_instance_v2" "eachfor_test1" {
	for_each	= toset(var.instance_name)
	name		= each.value
	flavor_id	= "3"
	security_groups	= ["default"]
	block_device {
	  uuid		= "d441320f-d026-44d3-b488-2979dc13c86b"
	  source_type	= "image"
	  volume_size	= 10
	  boot_index	= 0
	  destination_type ="volume"
	}

	network {
 	  name 		= "webnet"
	}
}

output "server_status" {
	value = [ for server in openstack_compute_instance_v2.eachfor_test1 : server.name ]
}
