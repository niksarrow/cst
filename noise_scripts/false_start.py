# Nikhil Saini
# IIT Bombay

# Add false starts to a sentence.
# Usage : python3 false_start.py <file_name> <lang> <probability_noise = alpha>
# Lang = {es,en}

import sys
from random import randrange
import numpy as np

np.random.seed(13) # to replicate results

assert len(sys.argv) == 4
fs_n = ['no'] if sys.argv[2] == 'en' else ['se']
fs_y = ['yes'] if sys.argv[2] == 'en' else ['ni']
# no in spanish ['ni', 'nadie', 'ninguno', 'nada', 'tampoco', ]

count = 0
count2 = 0

n = 1
p = float(sys.argv[3])
with open(sys.argv[1]+'.disfluent', 'a') as w:
    with open(sys.argv[1], 'r') as f:
         content = f.readlines()
         for line in content:
             line = line.split()
             if len(line) == 0: # empty line
                 line.append('\n')
                 w.write(''.join(line))
                 continue
             if line[0] in fs_n or line[0] in fs_y:
                 count += 1
                 num = np.random.binomial(n, p)
                 if num == 1: # change with 0.3 probability
                     count2 += 1
                     num = randrange(2) + 1
                     new_line = fs_y*num if line[0] in fs_n else fs_n*num if line[0] in fs_y  else []
                     line = new_line + line
             line.append('\n')
             w.write(' '.join(line))
print("Number of lines made disfluent : ",count2)
print("Total lines which were considered : ", count)
