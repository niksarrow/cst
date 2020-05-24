# Nikhil Saini
# IIT Bombay

# python3 remove_punc.py file.txt <Special_char> > newfile
# special char is any single char that is not present in file.
# If special char is an escape char, please add \ in command"

import sys,os, subprocess

if len(sys.argv) > 1:
    special_char='~'
else:
    special_char = sys.argv[2]

print("Running ... ")
# special_char = '^' # es
# sed -i'.bak' 's/$/~/' file
#special_char='{'
cmd = "wc "+sys.argv[1]
line_count_before = int(subprocess.check_output(cmd, shell=True).decode('utf-8').split()[0])
command = "sed -i'.bak' 's/$/" + special_char + "/' " + sys.argv[1]
os.system(command)
line_count_after = int(subprocess.check_output(cmd, shell=True).decode('utf-8').split()[0])
assert line_count_before == line_count_after

with open(sys.argv[1],'r') as f:
    content = f.read()
    # print(len(content))
    line = ""
    for i in content:
        if(i!=special_char):
            if ord(i) in [10, 13]:
                line = line + ' '
            elif not (ord(i) in [42, 44, 45, 46, 47, 58, 59, 63, 64, 92] or 33 <= ord(i) <= 37):
                line = line + i
        else:
            print(line.lstrip().rstrip())
            line=""

command = "sed -i'.bak' 's/"+special_char+"/ /' " + sys.argv[1]
#command = "sed -i'.bak' 's/\^/ /' " + sys.argv[1] # es
os.system(command)
line_count_after = int(subprocess.check_output(cmd, shell=True).decode('utf-8').split()[0])
print(line_count_before, line_count_after)
assert line_count_before == line_count_after
os.system('rm '+sys.argv[1]+'.bak')
