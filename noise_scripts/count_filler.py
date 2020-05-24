# Nikhil Saini
# IIT Bombay

# Usage : python3 count_filler.py <disfluent_file> <output_file> <lang>
# lang = {es, en}

import sys
from subprocess import check_output, STDOUT, CalledProcessError

assert len(sys.argv) == 4

fill_es = ['ah', 'eh', 'uh', 'am', 'um', 'em', 'oh', 'mm', 'hm', 'si'] # es
fill_en = [ 'hmm', 'hm', 'em', 'eh', 'uh', 'um', 'umm', 'oh', 'ah', 'aha', 'mm', 'wow', 'yes', 'ok'] #en
en_factor = float(1967852)/1440010 # no of words in mono en / no of words in disfluent en
es_factor = float(2292054)/1540719 # no of words in mono es / no of words in disfluent es
fill   = fill_en if sys.argv[3] == 'en' else fill_es
factor = en_factor if sys.argv[3] == 'en' else es_factor

file = sys.argv[1]

with open(sys.argv[2],'a') as w:
    for j in fill:
        filler = []
        filler.append(j)
        for i in range(1, 7):
            phrase = ' '.join(filler*i)
            cmd="grep -iwo '"+phrase+"' "+file+" | wc"
            try:
                count = check_output(cmd, shell=True, stderr=STDOUT).decode('utf-8')
                count = int(count.split()[0])
                returncode = 0
            except CalledProcessError as ex:
                count = ex.output.decode('utf-8')
                returncode = ex.returncode

            # print(phrase,count)
            w.write(phrase+","+str(count)+","+str(int(count*factor))+"\n")
