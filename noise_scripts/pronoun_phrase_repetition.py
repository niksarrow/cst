# Nikhil Saini
# IIT Bombay

# Phrase Repetition : Implementation of Pronoun Logic
# Usage : python3 pronoun_phrase_repetition.py <file_name> <lang> <noise prob = alpha
# lang = {en, es}

import sys
from random import randrange
import numpy as np

np.random.seed(13)

# Pronoun Set in en, es
en = ['i', 'we', 'you', 'he', 'she', 'it', 'they', "i'm"] # i'm is deliberately added, it is not a pronoun
es = ['yo', 'tú', 'usted', 'él', 'ella', 'nosotros', 'nosotras', 'vosotros', 'vosotras', 'ustedes', 'ellos', 'ellas']

assert len(sys.argv) == 4
lang = en if sys.argv[2] == 'en' else es

count = 0
count2 = 0
n = 1
p = float(sys.argv[3])

# in this code no prob value is implemented, all lines which become candidate are changed
with open(sys.argv[1]+'.pronoun_disfluent','a') as w:
    with open(sys.argv[1], 'r') as f:
        content = f.readlines()
        for line in content:
            line = line.split()
            if len(line) == 0:
                line.append('\n')
                w.write(' '.join(line))
                continue
            if line[0] in lang:
                count += 1
                num_words_repeat = randrange(3) + 1 # 1, 2,3
                if (num_words_repeat in [1]):
                    count2 += 1
                    line = line[0:num_words_repeat] + line
            line.append('\n')
            w.write(' '.join(line))
    print("Number of lines made disfluent : ",count2)
    print("Total lines which start with a pronoun :", count)
