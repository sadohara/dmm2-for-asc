import sys
import os
import json
import math

srcfile=sys.argv[1]
tagfile=sys.argv[2]
topn=int(sys.argv[3])
size=float(sys.argv[4])
keta=math.ceil(math.log10(size))
print('select_topn_code: srcfile:%s tagfile:%s topn=%u size=%u (%u)' % (srcfile, tagfile, topn, size, keta))

with open(srcfile, 'r') as fd:
    src = json.load(fd)
tag = dict()
for w in src:
    idxs = []
    for f in src[w]:
        n = 0
        s = 0
        for i in f:
            s = s * pow(10, keta) + i
            n += 1
            if n == topn:
                break
        idxs.append(s)
    tag[w] = idxs

with open(tagfile, 'w') as fd:
    json.dump(tag, fd, indent=2)
