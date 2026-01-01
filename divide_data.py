# divide_data.py
#
import sys
import json
import random
import subprocess

srcjson=sys.argv[1]
srcembd=sys.argv[2]
srclabs=sys.argv[3]
offsetfn=int(sys.argv[4])
json_outdir=sys.argv[5]
emb_outdir=sys.argv[6]
infix=sys.argv[7]
linfix=sys.argv[8]
suffix=sys.argv[9]
per_label = False
divide2 = 1
seed = 0
i = 10
while i < len(sys.argv):
    s = sys.argv[i]
    if s == '-per_label':
        per_label = True
    elif s == '-divide2':
        divide2 = int(sys.argv[i+1])
        i += 1
    elif s == '-seed':
        seed = int(sys.argv[i+1])
        i += 1
    i += 1

print('srcjson=%s, srcembd=%s, srclabs=%s, offsetfn=%02u, json_outdir=%s, emb_outdir=%s, json_infix=%s, lab_infix=%s, emb_suffix=%s, divide2=%u times, per_label=%s' % (srcjson, srcembd, srclabs, offsetfn, json_outdir, emb_outdir, infix, linfix, suffix, divide2, per_label), file=sys.stderr)


def output(data, labs, fn):
    tagdir = '%s/fold%02u' % (emb_outdir, offsetfn + fn)
    command = ['/bin/mkdir', '-p', tagdir]
    try:
        res = subprocess.run(command, stdout=sys.stdin, stderr=sys.stderr)
    except Exception as e:
        print(e)
        print('Cannot create %s!' % tagdir, file=sys.stderr)

    jsonfile = '%s/fold%02u.%s.json' % (json_outdir, offsetfn + fn, infix)
    print('Creating %s...' % jsonfile, file=sys.stderr)
    with open(jsonfile, 'w') as fd:
        json.dump(data, fd, indent=2)

    labfile = '%s/fold%02u.%s.json' % (json_outdir, offsetfn + fn, linfix)
    print('Creating %s...' % labfile, file=sys.stderr)
    with open(labfile, 'w') as fd:
        json.dump(labs, fd, indent=2)

    ps = tagdir.split('/')
    d = len(ps)
    prefix = ""
    for i in range(d):
        prefix += "../"
    n = 0
    for w in data:
        srcfile = '%s%s/%s.%s' % (prefix, srcembd, w, suffix)
        tagfile = '%s/%s.%s' % (tagdir, w, suffix)
        command = ['/bin/ln', '-s', srcfile, tagfile]
        try:
            res = subprocess.run(command, stdout=sys.stdin, stderr=sys.stderr)
            n += 1
        except Exception as e:
            print(e)
            print('Cannot create %s' % tagfile, file=sys.stderr)
    print('Making %u data in %s' % (n, tagdir), file=sys.stderr)


prng = random.Random()
prng.seed(seed)


with open(srclabs, 'r') as fd:
    labs = json.load(fd)


with open(srcjson, 'r') as fd:
    wsd = json.load(fd)
    ws = list(wsd.keys())
num = len(ws)
print('Read %s and found %u data' % (srcjson, num), file=sys.stderr)


def divide_it_2folds(fold, label):
    new_folds = [dict(), dict()]
    new_labels = [dict(), dict()]

    ls = dict()
    if per_label:
        for w in fold:
            l = labs[w][0]
            if not l in ls:
                ls[l] = []
            ls[l].append(w)
    else:
        ls[0] = list(fold.keys())

    for l in ls.keys():
        prng.shuffle(ls[l])
        n = len(ls[l])
        fnum = n // 2
        for j in range(n):
            w = ls[l][j]
            if j < fnum:
                f = 0
            else:
                f = 1
            new_folds[f][w]  = wsd[w]
            new_labels[f][w] = labs[w]
    return new_folds[0], new_folds[1], new_labels[0], new_labels[1]

def divide_list_2folds(folds, labels):
    num_folds = len(folds)
    assert len(labels) == num_folds, "Found a conflict on %u <> %" % (num_folds, len(labels))
    fs = []
    ls = []
    for i in range(num_folds):
        f1, f2, l1, l2 = divide_it_2folds(folds[i], labels[i])
        fs.append(f1)
        fs.append(f2)
        ls.append(l1)
        ls.append(l2)
    return fs, ls


folds  = [wsd]
labels = [labs]
for n in range(divide2):
    print('divide into 2^%u folds...' % (n+1), file=sys.stderr)
    folds, labels = divide_list_2folds(folds, labels)

for n in range(len(folds)):
    output(folds[n], labels[n], n+1)





