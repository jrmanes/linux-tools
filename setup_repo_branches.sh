#!/bin/bash

declare -a arr=("develop" "master")

for i in "${arr[@]}"
do
	echo "The branch is: $i"
	git branch $i && git checkout $i && git push --set-upstream origin $i 
done
