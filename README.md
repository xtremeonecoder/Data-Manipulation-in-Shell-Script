# Data-Manipulation-in-Shell-Script
Data Manipulation in Shell Script.


## Background:

### Task 1
- Create a script (script1.sh) in the dev_ops_bash directory
- The script should open the files in ./tmp - one by one - and read them line by line
- The script should look for IP address in the format 192.168.10. ???
- 192.168.10 corresponds to the network portion of the address
- If that address is found, it should be replaced with 192.168.20. ???
- Write to a copy of the original file. Rename it to the same name but .upd at the end

### Task 2
- Starting from script1.sh in exercise 1 and copy to script2.sh
- This script should change IP addresses based on name
- Example: 192.168.10.2 host1
- Enter file name to search in as arg1 ($ 1) (eg hosts)
- Enter hostname as arg2 ($ 2)
- Enter new ip address as arg3 ($ 3)
- Make sure you have three arguments
- Make sure the file exists 
- Search for hostname, if hit change ip address
- Print changed address to STDOUT
- Example ./

### Task 3
- Start from script2.sh in exercise 1 and copy to script3.sh
- Add the following check
- Arg1 $ 1 can have the following values
- -s for search Search for IP address or hostname. Write hit for STDOUT
- -b for switch Replace as in task 2 script2
- -r to delete Insert a # at the beginning of the line to annotate it
- If nothing specified, print an error message / instruction and exit
