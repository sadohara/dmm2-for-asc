import sys
import json


srcfile=sys.argv[1]
tagfile=sys.argv[2]
labfile=sys.argv[3]
olabfile=sys.argv[4]
labs = []
for i in range(len(sys.argv) - 5):
    labs.append(sys.argv[i+5])

print('srcfile=%s, tagfile=%s, labfile=%s, output_labelfile=%s, labels=%s' % (srcfile, tagfile, labfile, olabfile, ','.join(labs)), file=sys.stderr)


def read_json(filename):
    print('Reading %s...' % filename, file=sys.stderr)
    with open(filename, 'r') as fd:
        idxs = json.load(fd)
    return idxs

def write_json(filename, idxs):
    print('Writting %s...' % filename, file=sys.stderr)
    with open(filename, 'w') as fd:
        json.dump(idxs, fd, indent=2)

labels = read_json(labfile)
filtered = dict()
for w in labels:
    if not labels[w][0] in labs:
        filtered[w] = labels[w][0]

tag = dict()
lab = dict()
src = read_json(srcfile)
for k in src:
    if k in filtered:
        tag[k] = src[k]
        lab[k] = labels[k]

write_json(tagfile, tag)
write_json(olabfile, lab)

