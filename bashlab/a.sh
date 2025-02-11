#!/bin/bash 

#bash는 저수준 언어이다. 즉, 커널에  가깝다. >> 리눅스 커널에 의존적이다.
#고수준 언어는 application 단에 가깝다. 

echo "hello"
echo $PWD
echo $?
# $? : 0을 제외한 모든 결과는 오류 . 0 이면 정상 실행 

name="gildong" # 띄어쓰기 하면 안된다. 저수준 언어이기 때문이다. 
echo ${name}is what?
