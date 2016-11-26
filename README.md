# bash-scripting
projects using shell scripting
Instruction to run the code
1-the data base represented by a directory and the tables within it represented by files.
2-For each table inside the data base,there is two files describe it. 
3-one file contains the data describe the structure of the table (I called it meta data in the project) 
and its format is
                                             field_name     data_type   constrains
                                             any name       int or str        null,not(not null),pk
                                             all the fields are space separated 
4-second file contain the actual data
name of this file is same as its corresponding meta data file and automatically created by the function called create_tab_fun . All fields are space separated

5-when inserting data in the table must be inserted in the same sequence of the structure
6-all the fields have to me included while inserting process
7-to update or delete a certain record, you have to insert the corresponding primary key value
8-you can search for a certain field or fields via its name
9-you have to specify the path for the current data base you are working on
sample to run:
employees (meta data file)                                      employees_data(file contain data)
empno		int	pk				1	mohamed	alexandria
name		str	not				2	ahmed		cairo
add		str	null 				3	dody		null
>enter the path
.
>a display appears to select your function
>enter the name of meta table
employees
>go on

