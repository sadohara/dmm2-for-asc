import sys
import json
import glob


srcdir=sys.argv[1]
labdir=sys.argv[2]
tagdir=sys.argv[3]
srcinfix=sys.argv[4]
taginfix=sys.argv[5]
folds_str=sys.argv[6]
labs_str = sys.argv[7]
test_folds = []
for f in folds_str.split(','):
    test_folds.append(f)
labs_ignored = []
for l in labs_str.split(','):
    labs_ignored.append(l)
prefix="fold"
if len(sys.argv) > 8:
    prefix=sys.argv[8]

print('srcdir=%s, labdir=%s, tagdir=%s, prefix=%s, srcinfix=%s, taginfix=%s, test_folds:%s, labels_ignored:%s' % (srcdir, labdir, tagdir, prefix, srcinfix, taginfix, ','.join(test_folds), ','.join(labs_ignored)), file=sys.stderr)

def read_json(filename):
    print('Reading %s...' % filename, file=sys.stderr)
    with open(filename, 'r') as fd:
        idxs = json.load(fd)
    return idxs

def write_json(filename, idxs):
    print('Writting %s...' % filename, file=sys.stderr)
    with open(filename, 'w') as fd:
        json.dump(idxs, fd, indent=2)

wavs_ignored = dict()
for labfile in glob.glob('%s/%s*.json' % (labdir, prefix)):
    ps = labfile.split('/')
    f = ps[-1].split('.')[0]
    if not f in test_folds:
        labs = read_json(labfile)
        for w in labs:
            if labs[w][0] in labs_ignored:
                wavs_ignored[w] = 1
print('#ignored_wavfiles:%u' % len(wavs_ignored.keys()), file=sys.stderr)

sigs_ignored = dict()
for srcfile in glob.glob('%s/%s*.%s.json' % (srcdir, prefix, srcinfix)):
    ps = srcfile.split('/')
    f = ps[-1].split('.')[0]
    if not f in test_folds:
        src = read_json(srcfile)
        for w in src:
            if w in wavs_ignored:
                for s in src[w]:
                    sigs_ignored[s] = 1

sigs_accepted = dict()
sigs_acc_occrs = 0
sigs_fil_occrs = 0
for srcfile in glob.glob('%s/%s*.json' % (srcdir, prefix)):
    ps = srcfile.split('/')
    f = ps[-1].split('.')[0]
    src = read_json(srcfile)
    tag = dict()
    for w in src:
        tag[w] = []
        for s in src[w]:
            if s in sigs_ignored:
                s = -1
                sigs_fil_occrs += 1
            else:
                sigs_accepted[s] = 1
                sigs_acc_occrs += 1
            tag[w].append(s)
    write_json('%s/%s.%s.json' % (tagdir, f, taginfix), tag)

print('#accepted signals:%u(occ:%u), #filtered_signals:%u(occ:%u)' % (len(sigs_accepted.keys()), sigs_acc_occrs, len(sigs_ignored.keys()), sigs_fil_occrs), file=sys.stderr)


