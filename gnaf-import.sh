#!/bin/bash

STD_DIR="/home/ubuntu/projects/gnaf/gnaf_data/G-NAF/G-NAF MAY 2017/Standard"
AUTH_DIR="/home/ubuntu/projects/gnaf/gnaf_data/G-NAF/G-NAF MAY 2017/Authority Code"
directive=$1
dbname=$2

auth_tbl_pre="Authority_Code_";

suffix="_psv.psv"

#process standard folder
process_all_states() {
	states=("ACT" "NWS" "NT" "OT" "QLD" "SA" "TAS" "VIC" "WA")
#	states=("ACT")
	first_state="-delete"
	for state in "${states[@]}" ; do
        	process_a_state "$state" "$first_state"
		first_state=""
	done
}

process_a_state(){
	state_prefix=$1"_"
	#boolean
	delete_table=$2
	
	for filename in "$STD_DIR"/"$state_prefix"*.psv; do
	
		table_name="$(basename "$filename")"
		table_name="${table_name/$state_prefix/}"
		table_name="${table_name/$suffix/}"
	
		if [ delete_table == "-delete" ] ; then
			echo "Deleting table $table_name"
			psql -d $dbname -c "DELETE FROM $table_name;"
		fi
		
		echo "***importing table $table_name -- STATE: $state_prefix"

                psql -d $dbname -c "COPY $table_name FROM '$filename' delimiter '|' csv header;"
                
                echo "***Done table $table_name"
	done
}


#process psv files in authority folder
process_authority_files() {
	echo "Start import *.psv files in $psv_folder"
	for filename in "$AUTH_DIR"/*.psv; do

		table_name="$(basename "$filename")"
		echo $table_name
		table_name="${table_name/$auth_tbl_pre/}"
		echo $table_name
		table_name="${table_name/$suffix/}"

		
		echo "***delete table $table_name"
		psql -d $dbname -c "DELETE FROM $table_name;"

		echo "***importing table $table_name"

		psql -d $dbname -c "COPY $table_name FROM '$filename' delimiter '|' csv header;"
		
		echo "***Done table $table_name"

	done	
}

if [ "$dbname" == "" ]; then
	echo "Check the usage: "
	echo "1st parameter: -authority | -states"
	echo "2nd parameter: postgresql dataase name"
	exit
fi

if [ $directive == "-states" ]; then 
	#process_authority_files
	process_all_states
elif [ $directive == "-authority" ]; then
	#process authority tables
	process_authority_files
elif [ $directive == "-all" ]; then
	#import all
	process_authority_files
	process_all_states
fi
