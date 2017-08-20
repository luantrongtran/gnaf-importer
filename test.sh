#!/bin/bash
bo=$1
if [ "$bo" == "" ] 
then
	echo true
elif [ "$bo" == "1"  ]  
then
	echo false
else 
	echo "nothing"
fi
