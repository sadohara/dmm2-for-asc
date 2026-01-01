import os
import sys
import subprocess
import json
import glob

labfile=sys.argv[1]
codefile=sys.argv[2]
null=sys.argv[3]

with open(labfile, 'r') as f:
    labels = json.load(f)
with open(codefile, 'r') as f:
    codes = json.load(f)
assert len(labels) == len(codes), "len(%s) = %u <> %u = len(%s)\n" % (labfile, len(labels), len(codes), codefile)

files = sorted(labels.keys())

n = 0.0
w = 10.0
for f in files:
    if f in codes:
        cs = [str(i) for i in codes[f] if i >= 0]
    else:
        cs = []
    if len(cs) == 0:
        cs = [null]
    print('%.1f\t%.1f\t%s\t%s\t%s' % (n, n+w, ' '.join(cs), f, labels[f][0]))
    n += w

