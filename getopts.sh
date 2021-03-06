#!/bin/bash

FILE="/home/"$USER"/Desktop"
function usage()
{
	echo "use -f to specify the file. Your path is 'home/user/[yourfile]'"
	echo "use -s to display the results to stdout"
}

function commands(){
        while true
        do
        #date
        

        #ps -eo pid,ppid,cmd,%mem --sort=-%mem |head -n 10
	#c1=$(ps -eo %mem --sort=-%mem | awk 'NR==2 {print "max mem usage:"$1"%"}')
	c1=$(free -g | grep Mem | awk '{print "free mem:" $4}')
        
        #df -h 
	#c2=$(df -h --output=size --total | awk 'END {print "total space:" $4}')
       	c2=$(df -h / | awk 'END {print "available space:" $2}') 
        #uptime
	c3=$(uptime |awk '{print "15m load avarage:"$10}')
	
	#c4=$(ps -aux |grep "defunct" |wc -l)
	c4=$(ps -aux|grep -v grep|grep "defunct"|wc -l|awk '{print "zombieS:" $1}')

	c5=$(vnstat | grep today | awk '{print "rx:" $2$3 " tx:" $5$6}')


	echo $(date),$c1,$c2,$c3,$c4,$c5
      echo "_________________________________________________________________________________________________________________________"

        sleep 10s
        done
}

while getopts f:s param ; do
case $param in
	f)
	if ! [ -x "$(command -v vnstat)" ]; then
  echo 'Error: vnstat is not installed.' >&2
  exit 1
fi

        echo "press ctrl c to terminate the execution"

	 #commands 2>&1 1> $FILE/$2
	 commands &> $FILE/$2

	;;
	s)
	if ! [ -x "$(command -v bmon)" ]; then
  	 echo 'Error: bmon is not installed.' >&2
         exit 1
 	fi

	 commands
	;;
	*)
	echo "invalid argument"
	;;
esac
done

shift $((OPTIND-1))
usage
