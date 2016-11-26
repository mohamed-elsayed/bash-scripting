#!/bin/bash
#author:Mohamed Kandel
#project:building a DBMS (file based)

#for each table in data base we create two table meta_data and data file
#data type formates
str="[[:alpha:]]*"
int="[[:digit:]]*"
NULL="null"
NOT_NULL="not"

PS3="**********enter your selection***************"
#========================functions======================================

#+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
#=======================create data base===============================
function create_db_fun
{
	echo "enter data base name"
	read db

	mkdir ${db}
	cd ./${db}
	
}
#=======================end of create DB===============================
#========================create table===================================
#this function create the structure of the table 
#it is a file for each table in the data base contain info about the 
#fields of the table,data type(int,str), and constrain over each field (null or not null or pk)
function create_tab_fun
{
  
  #set -x
  echo -e "enter meta_table name:"
  read tab_name
  echo -e "enter your fields (field name,data type,constrain)"
  echo -e "\t enter EOF to exit or cont to continue"
  #use the flage to exit the creation process
  read flage
  #create the table structure
  while [ $flage != "EOF" ]
  do
  read line
  q=$(echo ${line} | cut -d" " -f1)
  if [ "${q}" == "EOF" ];then
    flage="EOF"
  else
    echo "${line}" >> $tab_name
  fi

  done
  #set +x
  unset line
  unset flage
  unset tab_name
}
#=======================create table end================================

#======================insert record====================================
function insert_record_fun
{
#set -x
echo -e "enter meta_table name"
#table contain info about data base table
#name of table contain data= tab_name_data
read tab_meta
tab_name_data=${tab_meta}_data

#calculate number of fields
x=$(cat ${tab_meta} | cut -d" " -f1|wc -l)

echo -e "enter your data \n"
#data must be entered as the same order of file structure
read -a field

#check for number of arguments entered
flage=0
if [ ${#field[@]} -gt $x ]
then
	echo "Too much arguments"
	flage=1
else
	if [ ${#field[@]} -lt $x ]
	then
		echo "Few arguments"
		flage=1
	fi
fi

#read constrains field and data types field
i=0
while  read y  
do
	if [ $flage -eq  1 ]
	then
	break
	fi
   #check for data type

   datatype=$(echo ${y} | cut -d" " -f2 )

   if [ ${datatype} == "str" ]
   then
   		if [[ "${field[i]}"  == ${str} ]]
		then
			echo "true string"
		else
			echo "wrong data type entry"
			flage=1
			break
		fi
   else
		if [ ${datatype} == "int" ]
		then
			if [[ ${field[i]} == ${int} ]] 
			then
				echo "true int"
			else
				echo "wrong data type entry"
				flage=1
				break

			fi
		fi
   fi


   #check for constrains
   #available constrains are NULL NOT_NULL PK
   constrain=$(echo ${y} | cut -d" " -f3)
	if [ ${constrain} == $NOT_NULL ]
	then
		if [ ${field[i]} == $NULL ]
		then 
			echo "Error: the field number $i must have a value"
			flage=1
			break
		fi
	else
		if [ ${constrain} == "pk" ]
		then 
			#check for uniqueness
			cut -d" " -f1 ${tab_name_data} | grep "${field[i]}"
			if [ $? -eq 0 ]
			then
				echo "Error: primary key must be uniqu"
				flage=1
				break
			else
				#check for not null
				if [ ${field[i]} == $NULL ]
				then 
					echo "Error: primary key must be not_null"
					flage=1
					break
				else
					echo "Good primary key value"
				fi
			fi
		fi
	fi
   i=$(($i+1))
   
done < ${tab_meta}
if [ $flage -ne 1 ]
then
#insertion of data in DB
echo ${field[*]} >> ${tab_name_data}
fi
#set +x
unset i x y flage
}
#=====================insert record end=================================

#=====================update record fun=================================
#this function used to update a certain record based on the value of pk
function update_record_fun
{

#	set -x
	#insert_record_fun
	echo "enter the name of meta data table"
	read tab_meta

	tab_name_data=${tab_meta}_data

	echo "Enter the (primary key value for record to update)"
	read pk

	flage=0
	
	record_data=$(grep  "$pk" ${tab_name_data})
	if [ -z "$record_data"  ]
	then
		flage=1
		echo "Error:Does not exist pk"
	else
		echo ${record_data}
	
		#check for data integrity
		#calculate number of fields
		x=$(cat ${tab_meta} | cut -d" " -f1|wc -l)

		echo -e "enter your data \n"
		#data must be entered as the same order of file structure
		read -a field
		#check for number of arguments entered
	
		if [ ${#field[@]} -gt $x ]
		then
			echo "Too much arguments"
			flage=1
		else
			if [ ${#field[@]} -lt $x ]
			then
				echo "Few arguments"
				flage=1
			fi
		fi
	fi
	#read constrains field and data types field
	i=0
	while  read y  
	do
		if [ $flage -eq  1 ]
		then
			break
		fi
   	#check for data type

   	datatype=$(echo ${y} | cut -d" " -f2 )

   		if [ ${datatype} == "str" ]
   		then
   			if [[ "${field[i]}"  == ${str} ]]
			then
				echo "true string"
			else
				echo "wrong data type entry"
				flage=1
				break
			fi
  		 else
			if [ ${datatype} == "int" ]
			then
				if [[ ${field[i]} == ${int} ]] 
				then
					echo "true int"
				else
					echo "wrong data type entry"
					flage=1
					break

				fi
			fi
   		fi


  	 #check for constrains
  	 #available constrains are NULL NOT_NULL PK
   	constrain=$(echo ${y} | cut -d" " -f3)
	if [ ${constrain} == $NOT_NULL ]
	then
		if [ ${field[i]} == $NULL ]
		then 
			echo "Error: the field number $i must have a value"
			flage=1
			break
		fi
	else
		if [ ${constrain} == "pk" ]
		then 
			#check for uniqueness
			cut -d" " -f1 ${tab_name_data} | grep "${field[i]}"
			if [ $? -eq 0 ]
			then
				echo "Error: primary key must be uniqu"
				flage=1
				break
			else
				#check for not null
				if [ ${field[i]} == $NULL ]
				then 
					echo "Error: primary key must be not_null"
					flage=1
					break
				else
					echo "Good primary key value"
				fi
			fi
		fi
	fi
   i=$(($i+1))
   
done < ${tab_meta}
	#update data in the DB
if [ $flage -ne 1 ]
then
	cat ${tab_name_data} > temp
	sed s:"${record_data}":"${field[*]}": < temp > ${tab_name_data}
	sort -nk1 -t" " ${tab_name_data}
	rm temp
fi
#set +x
unset data  pk flage

}

#====================update record end=================================

#===================delete record fun==================================
function delete_record_fun
{
#	set -x
	echo "enter the name of the meta data table"
	read tab_meta

	tab_name_data=${tab_meta}_data

	echo "enter the (primary key value for the record to delete)"
	read pk

	record_data=$(grep "$pk" ${tab_name_data})
	cat ${tab_name_data} > temp
	sed /"${record_data}"/d < temp > ${tab_name_data}

#	set +x
rm temp
}

#==================delete record end===================================

#=================drop function=======================================

function drop
{
	echo "enter the name of the meta data of table"
	read tab_meta

	tab_name_data=${tab_meta}_data
	if [ -f ${tab_meta} ]
	then
		rm ${tab_meta}
		echo "meta data file removed"
	else
		echo "Error:does not exist meta data file"
	fi

	if [ -f ${tab_name_data} ]
	then
		rm ${tab_name_data}
		echo "data file removed"
	else
		echo "Error:does not exist data file"	
	fi

}

#================end of drop function==================================

#===============truncate function=====================================
function truncate
{
	echo "enter the name of the meta data of table"
	read tab_meta

	tab_name_data=${tab_meta}_data
	if [ -f ${tab_name_data} ]
	then
		rm ${tab_name_data}
		echo "data file removed"
	else
		echo "Error : does not exist data file"
	fi
}

#==============end of truncate function==============================

#=============alter function========================================
function alter 
{
#	set -x
	echo "enter the name of meta data table"
	read tab_meta
	tab_name_data=${tab_meta}_data
	echo "enter (add or drop)"
	read status

	if [ "${status}" == "add" ]
	then
		echo "enter the new field(name,datatype,constrain)"
		read -a data
	    echo "${data[*]}" >> ${tab_meta}

	else
		if [ "${status}" == "drop" ]
		then
			echo "enter the name of the field to drop"
			read drop_f
			#specifiy record field number and value
			drop_record=$(grep -n "${drop_f}" ${tab_meta})
			cat ${tab_meta} > temp
			num=${drop_record::1}
			record=${drop_record:2}
			#remove record from meta data table
			sed /"${record}"/d < temp > ${tab_meta}

			#remove the colum from data table
			cat ${tab_name_data} > temp
			awk '{$'$num'="";print $0}' temp > $tab_name_data
			rm temp
		fi
	fi
#	set +x
}

#=============end of alter==========================================


#========================search function=================================
#this function will display fields required by user
function search_fun
{
	#set -x

	echo "enter the name of meta data file"
	read tab_meta
	tab_name_data=${tab_meta}_data
	echo "enter the fields to display seperated by space"
	read -a field
	flag=0
	x=$(cat ${tab_meta} | wc -l)
	for i in ${field[*]}
		do
    		if [ $i -gt $x ]
			then
			flag=1

			fi
		done
		
		if [ $flag -eq 0 ]
		then
			y=$(echo ${field[*]} | sed s/" "/,/g)
			z=$(cut -d" " -f1 ${tab_meta})
			#append tha table format
			echo $z > temp
			cat ${tab_name_data} >> temp
			echo -e "\n \n"
			echo "============fields are====================="
			cut -d" " -f${y} temp
		
		else
			echo "Error:fields value"
		fi

#set +x
unset x y z flag
rm temp
}

#=======================end of search ===================================

#========================dispaly function================================
function display_fun
{
	#set -x
	echo "enter the name of meta data table"
	read tab_meta
	tab_name_data=${tab_meta}_data
	echo -e "\n \n"
	echo -e "==================table data========================"
	header=$(cut -d" " -f1 ${tab_meta})
	echo $header
	awk '{print $0}' $tab_name_data
	echo -e "====================================================="
	#set +x
	unset header
}
#=======================end od display===================================
#=======================funs_end========================================
#========================menu============================================
echo "enter the path for data base"
read path_db
cd ${path_db}
select item in create_DB create_tab alter_tab insert_rec del_rec search display update_rec drop_tab truncate_tab end
do
  case $item in
       create_DB)
	   				create_db_fun
	   				;;
	   create_tab)
	   				create_tab_fun
					;;
	   alter_tab)
	   				alter
	   				;;
	   insert_rec)
					insert_record_fun
	   				;; 
	   del_rec)
	   				delete_record_fun
	   				;;
	   search)
	   				search_fun
	   				;;
	   display)
	   				display_fun
	   				;;
	   update_rec)
	   				update_record_fun
	   				;;
	   drop_tab)
	   				drop
	   				;;
	   truncate_tab)
	   				truncate
	   				;;
	   end)
	   			break
					;;
  esac
done
#=======================menu_end=========================================


