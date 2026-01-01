# divide_data.py
#
import sys
import json
import glob

labfile=sys.argv[1]
jsondir=sys.argv[2]
jsonsuffix=sys.argv[3]
print('stat_jsonfiles.py: labfile=%s, jsondir=%s, suffix=%s' % (labfile, jsondir, jsonsuffix), file=sys.stderr)


l2i = dict()
i2l = dict()
with open(labfile, 'r') as fd:
    line = fd.readline()
    while line:
        line = line.strip()
        ps = line.split('\t')
        lab = ps[1]
        idx = int(ps[0])
        l2i[lab] = idx
        i2l[idx] = lab
        line = fd.readline()

def stat_jsonfile(jsonfile, mins, maxs, sums):
    labs = dict()
    with open(jsonfile, 'r') as fd:
        labs = json.load(fd)
    print('> Read %s and found %u data' % (jsonfile, len(labs)), file=sys.stderr)

    count = []
    for i in range(len(mins)):
        count.append(0)
    for w in labs:
        lab = labs[w][0]
        idx = l2i[lab]
        count[idx] += 1

    ctr = 0
    for i in idxs:
        lab = i2l[i]
        c = count[i]
        print("%02u %6u %s" % (i, c, lab), file=sys.stderr)
        sums[i] += c
        if c > maxs[i]:
            maxs[i] = c
        if mins[i] is None or c < mins[i]:
            mins[i] = c
        ctr += c
    print("** %6u" % ctr, file=sys.stderr)


idxs = sorted(i2l.keys())
sums = []
mins = []
maxs = []
for i in idxs:
    sums.append(0)
    mins.append(None)
    maxs.append(0)

num = 0
for f in glob.glob("%s/*.%s" % (jsondir, jsonsuffix)):
    stat_jsonfile(f, mins, maxs, sums)
    num += 1

ctr = 0
for i in idxs:
    lab = i2l[i]
    print("%02u %20s: %6u/%3u = %5.1f = ave,  min = %5.1f max = %5.1f" % (i, lab, sums[i], num, sums[i]/num, mins[i], maxs[i]))
    ctr += sums[i]
print("** %6u/%3u = %5.1f" % (ctr, num, ctr/num))








