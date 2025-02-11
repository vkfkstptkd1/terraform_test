resource "openstack_compute_instance_v2" "basic-instance01" {
  name            = "basic-instance01"
  image_id        = "e1176e60-20a1-40b7-8f65-93ab01920a15"
  flavor_id       = "7"
  key_pair        = "lab-openstack-0206"
  security_groups = ["default","permit-jenkins"]

  network {
    name = "webnet"
  }

# lifecycle : 
  lifecycle {
    create_before_destroy = true
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


# 인스턴스에 접속하기 위한 정보 입력 & provision 
# remote-exec : 그 인스턴스 안에서 ~ 실행해. # local-exec : 로컬에서 실행해 ~ 
resource "terraform_data" "apply" {
  connection {
	type = "ssh"
	user = "rocky"
	private_key = "${file("/root/terraformlab/ch5_test1/lab-terraform.pem")}"
	host = openstack_networking_floatingip_v2.floating_ip.address
  }
  provisioner "file" {
  	source = "/root/terraformlab/ch5_test1/httpd.sh"
	destination = "/home/rocky/httpd.sh"
  }
  provisioner "remote-exec" {
	inline = [
	  "chmod +x /home/rocky/httpd.sh",
	  "sudo /bin/bash /home/rocky/httpd.sh"
	]
  }
  triggers_replace = [ 
    	openstack_networking_floatingip_v2.floating_ip.address
  ]

}
