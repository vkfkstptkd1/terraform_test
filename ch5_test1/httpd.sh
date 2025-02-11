#!/bin/bash

which httpd

if [ $? -eq 0 ]
then
        echo ""
else
        sudo yum -y install httpd
	sudo systemctl restart httpd
fi


