# Nikhil Saini
# IIT Bombay

# Usage : python3 augment_fill.py <out> <lang>
# Ex: python3 augment_fill.py top.en.punc en
# Ex: python3 augment_fill.py bottom.es.punc es
# This scripts creates a new file containing sentences only fillers.

import sys, random

assert len(sys.argv) == 3

fill_es = ['ah', 'eh', 'uh', 'am', 'um', 'em', 'oh', 'mm', 'hm'] # es
fill_en = [ 'hmm', 'hm', 'em', 'eh', 'uh', 'um', 'umm', 'oh', 'ah', 'aha', 'mm'] #en

fill = fill_es if sys.argv[2] == 'es' else fill_en

with open(sys.argv[1],'a') as w:
    for i in range(5000):
        w.write(random.choice(fill_es)+"\n")
