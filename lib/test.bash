before_intr@b2cd1aad8a55:/osprojectfourthyear$ cat admins.txt
admin1
adminx


before_intr@b2cd1aad8a55:/osprojectfourthyear$ su adminx

Password: 



adminx@b2cd1aad8a55:/osprojectfourthyear$ sudo ./retrieve_data.bash 
[sudo] password for adminx: 
Available Databases:
db_test
library
school
test
test_access_db
Select a database: