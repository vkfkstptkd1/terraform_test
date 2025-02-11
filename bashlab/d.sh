#/!bin/bash

# 사용자로부터 이름 입력 > 입력이 없으면 "이름이 입력 x" 입력이 있으면 "길동님 반갑습니다 출력 후 종료


echo -n "이름을 입력해 주세요: "
read name 
if [ -z $name ]
then
	echo " 이름이 입력되지 않았습니다."
else
	echo " ${name}님 반갑습니다. "
fi
