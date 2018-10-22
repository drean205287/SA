#!/bin/sh

curl_course(){
	#rm table.txt
curl 'https://timetable.nctu.edu.tw/?r=main/get_cos_list' --data 'm_acy=107&m_sem=1&m_degree=3&m_dep_id=17&m_group=**&m_grade=**&m_class=**&m_option=**&m_crsname=**&m_teaname=**&m_cos_id=**&m_cos_code**&m_crstime=**&m_crsoutline=**&m_costype=**' | awk '{n=split($0,a,/["]/);}END{printf("_");for(i=1;i<=n;i++){if(a[i]=="cos_time"){printf("%s.",a[i+2])}if(a[i]=="cos_ename")printf("%s_",a[i+2])}}' > course1.txt
cat course1.txt | awk '{cnt=split($0,b,/_/)}END{for (j=0;j<=cnt;j++){gsub(/ /,".",b[j]);printf("%s\n",b[j])}}' > course.txt 
	show_table
} 
add_course(){
a=""
i=0

cat course.txt | while read line;
do	#echo $i
	i=$((i+1))
	a="${a} $line"	#	echo $a
	if [ $i -eq 132  ] ; then
		tag="$(dialog --stdout --clear --begin 1 1 --no-items --title "course" --menu "Add course" 50 100 16 $a)"
		status=$?
		case $status in
			0) #OK
				echo $tag;;
						
		        1) #cancel
				;; 
	        esac
	#	dialog --stdout --begin 0 0 --title "table" --extra-button --extra-label "Add course" --msgbox "111" 100 100
	#	status=$?
	#	echo $status		
	fi
done  >> table.txt
	collision
#echo $a
#dialog --title "course" --menu "Add course" 100 50 70 $a
}
detail(){
	cat table.txt | awk '{n=split($0,a)}END{
	for(i=1;i<=n;i++){
		room=""
		for(j=1;j<=length(a[i]);j++){
			dash=substr(a[i],j,1)
			if(dash=="-"){
				for(k=1;k<=length(a[i]);k++){
					dot=substr(a[i],j+k,1)
					room=room "" dot;
					if(dot=="."){
						class=substr(a[i],j+k+1,length(a[i])-j-k)
						class=class "." room
						j=length(a[i])
						k=j
					}
					else{
						if(dot==","){
							for(;k<=length(a[i]);k++){
								if(substr(a[i],j+k,1)=="-"){
									break
								}
							}
						}
					}
				}
			}
		}
		for(j=1;j<=length(a[i]);j++){
			str=substr(a[i],j,1)
			if(str~/[1-7]/){
				for(k=1;k<=length(a[i]);k++){
					str1=substr(a[i],j+k,1)
					if(str1~/[A-Z]/){
						c[str,str1]=class
						f[str,str1]=1
						cnt[str,str1]=int(length(class)/13)+1
					}
					else{
						if(str1=="-"){
							for(;k<=length(a[i]);k++){
								if(substr(a[i],j+k,1)=="."){
									k=length(a[i])
									j=k
								}
								else{	
									if(substr(a[i],j+k,1)==","){
										j=j+k
										k=length(a[i])
									}
								}
							}
							
							
						}
						else{
							if(str1~/[1-7]/){
								str=str1
							}
						}
					}
				}
			}
		}
	}
	t[1]="M"
	t[2]="N"
	t[3]="A"
	t[4]="B"
	t[5]="C"
	t[6]="D"
	t[7]="X"
	t[8]="E"
	t[9]="F"
	t[10]="G"
	t[11]="H"
	t[12]="Y"
	t[13]="I"
	t[14]="J"
	t[15]="K"
	d[1]="1"
	d[2]="2"
	d[3]="3"
	d[4]="4"
	d[5]="5"
	d[6]="6"
	d[7]="7"
	printf("x  .Mon            .Tue            .Wed            .The            .Fri            .Sat            .Sun\n")
	for(i=1;i<=15;i++){
		printf("%s  |",t[i])
		for(j=1;j<=7;j++){
			if(f[d[j],t[i]]==1){
				count=0
				for(k=1;k<=13&&k<=length(c[d[j],t[i]]);k++){
					printf("%s",substr(c[d[j],t[i]],k,1))
					count++
				}
				for(k=1;k<=13-count;k++){
					printf(" ")
				}
				printf("  |")
			}
			else{
				printf("x.             |")
			}
		}
		printf("\n.  |")
		for(j=1;j<=7;j++){
			count=0
			if(cnt[d[j],t[i]]>=2){
				for(k=14;k<=26&&k<=length(c[d[j],t[i]]);k++){
					count++
					printf("%s",substr(c[d[j],t[i]],k,1))
				}
			}
			else{	count=1
				printf(".")
			}
			for(k=1;k<=15-count;k++){
				printf(" ")
			}
			printf("|")
		}
		printf("\n.  |")
		for(j=1;j<=7;j++){
			count=0
			if(cnt[d[j],t[i]]>=3){
				for(k=27;k<=39&&k<=length(c[d[j],t[i]]);k++){
					count++
					printf("%s",substr(c[d[j],t[i]],k,1))
				}
			}
			else{	count=1
				printf(".")
			}
			for(k=1;k<=15-count;k++){
				printf(" ")
			}
			printf("|")
		}
		printf("\n.  |")
		for(j=1;j<=7;j++){
			count=0
			if(cnt[d[j],t[i]]>=4){
				for(k=40;k<=52&&k<=length(c[d[j],t[i]]);k++){
					count++
					printf("%s",substr(c[d[j],t[i]],k,1))
				}
			}
			else{	count=1
				printf(".")
			}
			for(k=1;k<=15-count;k++){
				printf(" ")
			}
			printf("|")
		}
		printf("\n.  |")
		for(j=1;j<=7;j++){
			count=0
			if(cnt[d[j],t[i]]>=5){
				for(k=53;k<=65&&k<=length(c[d[j],t[i]]);k++){
					count++
					printf("%s",substr(c[d[j],t[i]],k,1))
				}
			}
			else{	count=1
				printf(".")
			}
			for(k=1;k<=15-count;k++){
				printf(" ")
			}
			printf("|")
		}
		printf("\n")
		printf("=  ==============  ==============  ==============  ==============  ==============  ==============  ==============\n")
	}
	}' > show.txt
	dialog  --title "table" --ok-label "Add course"  --extra-button --extra-label "Option" --help-button --help-label "Exit" --textbox show.txt 100 100
	status=$?
	case $status in
		0) 	#addcourse
			add_course;;
		3)	#option
			echo "0" > mode.txt
			show_table;;
		2) 	#exit
			;;
	esac	
}
show_table(){	
	cat table.txt | awk '{n=split($0,a)}END{
	for(i=1;i<=n;i++){
		for(j=1;j<=length(a[i]);j++){
			dash=substr(a[i],j,1)
			if(dash=="-"){
				for(k=1;k<=length(a[i]);k++){
					dot=substr(a[i],j+k,1)
					if(dot=="."){
						class=substr(a[i],j+k+1,length(a[i])-j-k)
						j=length(a[i])
						k=j
					}
				}
			}
		}
		for(j=1;j<=length(a[i]);j++){
			str=substr(a[i],j,1)
			if(str~/[1-7]/){
				for(k=1;k<=length(a[i]);k++){
					str1=substr(a[i],j+k,1)
					if(str1~/[A-Z]/){
						c[str,str1]=class
						f[str,str1]=1
						cnt[str,str1]=int(length(class)/13)+1
					}
					else{
						if(str1=="-"){
							for(;k<=length(a[i]);k++){
								if(substr(a[i],j+k,1)=="."){
									k=length(a[i])
									j=k
								}
								else{
									if(substr(a[i],j+k,1)==","){
										j=j+k
										k=length(a[i])
									}
								}
							}
							
							
						}
						else{
							if(str1~/[1-7]/){
								str=str1
							}
						}
					}
				}
			}
		}
	}
	t[1]="A"
	t[2]="B"
	t[3]="C"
	t[4]="D"
	t[5]="E"
	t[6]="F"
	t[7]="G"
	t[8]="H"
	t[9]="I"
	t[10]="J"
	t[11]="K"
	d[1]="1"
	d[2]="2"
	d[3]="3"
	d[4]="4"
	d[5]="5"
	printf("x  .Mon            .Tue            .Wed            .The            .Fri\n")
	for(i=1;i<=11;i++){
		printf("%s  |",t[i])
		for(j=1;j<=5;j++){
			if(f[d[j],t[i]]==1){
				count=0
				for(k=1;k<=13&&k<=length(c[d[j],t[i]]);k++){
					printf("%s",substr(c[d[j],t[i]],k,1))
					count++
				}
				for(k=1;k<=13-count;k++){
					printf(" ")
				}
				printf("  |")
			}
			else{
				printf("x.             |")
			}
		}
		printf("\n.  |")
		for(j=1;j<=5;j++){
			count=0
			if(cnt[d[j],t[i]]>=2){
				for(k=14;k<=26&&k<=length(c[d[j],t[i]]);k++){
					count++
					printf("%s",substr(c[d[j],t[i]],k,1))
				}
			}
			else{	count=1
				printf(".")
			}
			for(k=1;k<=15-count;k++){
				printf(" ")
			}
			printf("|")
		}
		printf("\n.  |")
		for(j=1;j<=5;j++){
			count=0
			if(cnt[d[j],t[i]]>=3){
				for(k=27;k<=39&&k<=length(c[d[j],t[i]]);k++){
					count++
					printf("%s",substr(c[d[j],t[i]],k,1))
				}
			}
			else{	count=1
				printf(".")
			}
			for(k=1;k<=15-count;k++){
				printf(" ")
			}
			printf("|")
		}
		printf("\n.  |")
		for(j=1;j<=5;j++){
			count=0
			if(cnt[d[j],t[i]]>=4){
				for(k=40;k<=52&&k<=length(c[d[j],t[i]]);k++){
					count++
					printf("%s",substr(c[d[j],t[i]],k,1))
				}
			}
			else{	count=1
				printf(".")
			}
			for(k=1;k<=15-count;k++){
				printf(" ")
			}
			printf("|")
		}
		printf("\n")
		printf("=  ==============  ==============  ==============  ==============  ==============\n")
	}
	}' > show.txt
	dialog  --title "table" --ok-label "Add course"  --extra-button --extra-label "Option" --help-button --help-label "Exit" --textbox show.txt 100 100
	status=$?
#	echo $status
	case $status in
		0) 	#addcourse
			add_course;;
		2)	#exit
			;;
		3) 	#option
			echo "1" > mode.txt
			detail;;
	esac	
}
collision(){
cat table.txt | awk '{n=split($0,a)}END{
	fc=0
	for(i=1;i<=n;i++){
		for(j=1;j<=length(a[i]);j++){
			str=substr(a[i],j,1)
			if(str~/[1-7]/){
				for(k=1;k<=length(a[i]);k++){
					str1=substr(a[i],j+k,1)
					if(str1~/[A-Z]/){	
						if(c[str,str1]==1){	
							fc=1
							k=length(a[i])
							j=k
							i=n
						}
						else{	c[str,str1]=1
							fc=0
							
						}	
					}
					else{	
						if(str1=="-"){
							for(;k<=length(a[i]);k++){
								if(substr(a[i],j+k,1)=="."){
									k=length(a[i])
									j=k
								}
								else{
									if(substr(a[i],j+k,1)==","){
										j=j+k
										k=length(a[i])
									}
								}
							}
							
						}
						else{
							if(str1~/[1-7]/){
								j=j+k-1
								k=length(a[i])
							}
						}
					}	
				}
			}
		}
}
	if(fc==1){
		for(l=1;l<n;l++){
			printf("%s ",a[l])	
		}	
	}
	else{	
		for(l=1;l<=n;l++){
			printf("%s ",a[l])
		}	
	}
}' > tablefix.txt 
	if  diff -q -b -B table.txt tablefix.txt ; then
		cp tablefix.txt table.txt
		while read line;
		do
			if [ $line -eq 0 ]; then
				show_table
			else
				detail
			fi
		done < mode.txt
	else
		cp tablefix.txt table.txt
		dialog --title "collision" --msgbox "class collision" 10 30
		add_course
	fi	
#	cp tablefix.txt table.txt
}
if [ ! -f "mode.txt" ]; then
	echo "0" > mode.txt
fi
if [ ! -f "course.txt" ]; then
	curl_course
else	
	while read line;
	do	
		echo $line
		if [ $line -eq 0 ]; then
			show_table
		else
			detail
		fi
	done < mode.txt
fi
