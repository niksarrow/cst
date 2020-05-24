# Nikhil Saini
# IIT Bombay

# Phrase Repetition : Implementation of 'single word repetition' and 'small phrase repetition'
# Usage : python3 phrase_repetition_fluent.py <file_name> <noise probability = alpha>

import sys
from random import randrange
import numpy as np

np.random.seed(13)

assert len(sys.argv) == 3

count = 0
count2 = 0
n = 1
p = float(sys.argv[2])

with open(sys.argv[1]+'.phrase_rep_disfluent','a') as w:
    with open(sys.argv[1], 'r') as f:
        content = f.readlines()
        for line in content:
            line = line.split()
            length = len(line)
            if length < 5:  # if length of line is upto 5, do no repeat anything
                line.append('\n')
                w.write(' '.join(line))
                continue
            num = np.random.binomial(n,p) 
            # print("num",num)
            if num == 1:
                num = randrange(3) + 1 # 1, 2, 3
                while 1: # To ensure we have as many words from index to end, for repetition
                    index = randrange(length) # randomly select one index from 0 to len-1
                    # print("index",index)
                    # print("length", length)
                    if num <= length - index :
                        new_line = line[0:index+num] + line[index:index+num] + line[index+num:]
                        # print(new_line)
                        count += 1
                        break
            else:
                new_line = line
                count2 += 1
            new_line.append('\n')
            w.write(' '.join(new_line))
    print("Number of lines made disfluent : ",count)
    print("Total lines considered : ", count+count2)
