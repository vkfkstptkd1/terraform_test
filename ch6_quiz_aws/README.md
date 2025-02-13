aws 실습 한거			
ch6_test2			
	nat 추가 및 공인 ip 없게. 대신, nat이 먼저 만들어져야 한다 !!!  그래야 instance 만들어지고 나서 인터넷 접근이 가능하다.(yum install.. )		
		depends on	
		or userdata를 사용하지 말아야 한다. Provisioner를 써야 될 수도 있다. (빠르게 연결이 안되는 경우)	
		provisioner remote exec // or ansible 사용 	

