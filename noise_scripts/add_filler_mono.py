# Nikhil Saini
# IIT Bombay

# Usage : python3 add_filler_mono.py <in_csv_file> <in_mono_file
# Ex: python3 add_filler_mono.py fill.en top.en.punc
# Ex: python3 add_filler_mono.py fill.es bottom.es.punc

import sys
from random import randrange
import random



assert len(sys.argv) == 3

_dict = {}
with open(sys.argv[1],'r') as f:
    content = f.readlines()
    for line in content:
        line = line.split(",")
        _dict[line[0]] = line[1]

count = 0
count2 = 0
dict_empty = False
with open(sys.argv[2],'r') as f:
    with open(sys.argv[2]+'.filler','a') as w:
        content = f.readlines()
        for line in content:
            line = line.split()
            length = len(line)
            if length > 0 and dict_empty == False:
                index = randrange(length)
                key = random.choice(list(_dict.keys())) # key is a filler word/phrase
                _dict[key] = str(int(_dict[key]) - 1)
                if _dict[key] == "0":
                    del _dict[key]
                li = []
                li.append(key)
                prob = randrange(10)
                if prob not in [1]: # controls % of sentence affected.
                    count2 += 1
                    li = []
                new_line = line[0:index] + li + line[index:]
                new_line.append('\n')
                w.write(' '.join(new_line))
                count += 1
            else:
                line.append("\n")
                w.write(' '.join(line))
            if len(_dict) == 0:
                dict_empty=True

print("No of lines affected in mono file = ",count-count2)
print("Total lines considered = ",count)
