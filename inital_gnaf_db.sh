DIR="/home/ubuntu/projects/gnaf/gnaf_data/G-NAF/Extras/GNAF_TableCreation_Scripts"

create_table_script="$DIR/create_tables_ansi.sql"
add_fk_constrains_script="$DIR/add_fk_constraints.sql"

directive="$1"
dbname="$2"

echo "$directive"
echo "$dbname"

if [ $dbname == "" ]; then
	echo "Must enter a database name"
	exit
fi

if [ $directive == "-table" ]; then
	psql -d "$dbname" -a -f "$create_table_script"
elif [ $directive == "-constraints" ]; then
	psql -d "$dbname" -a -f "$add_fk_constrains_script"
else
	echo "undefined directive: $directive"
fi

