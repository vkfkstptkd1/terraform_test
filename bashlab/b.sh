#!/bin/bash 

ech hello 2> /dev/null

if [ $? -eq 0 ]
then
	echo "정상"
else
	echo "비정상"
fi
