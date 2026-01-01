import sys
import json


srcfile=sys.argv[1]
tagfile=sys.argv[2]
node=sys.argv[3]
print('srcfile=%s, tagfile=%s, filtered by %s' % (srcfile, tagfile, node), file=sys.stderr)


def read_json(filename):
    print('Reading %s...' % filename, file=sys.stderr)
    with open(filename, 'r') as fd:
        idxs = json.load(fd)
    return idxs

def write_json(filename, idxs):
    print('Writting %s...' % filename, file=sys.stderr)
    with open(filename, 'w') as fd:
        json.dump(idxs, fd, indent=2)

tag = dict()
src = read_json(srcfile)
for k in src:
    if node in k:
        tag[k] = src[k]
write_json(tagfile, tag)

