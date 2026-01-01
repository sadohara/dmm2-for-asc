import sys
import json
import subprocess

src_embdir=sys.argv[1]
tag_embdir=sys.argv[2]
src_jsonfile=sys.argv[3]
tag_jsonfile=sys.argv[4]
ident=sys.argv[5]
name=sys.argv[6]
print('embedding:%s -> %s, json:%s -> %s, filtered by %s(%s)' % (src_embdir, tag_embdir, src_jsonfile, tag_jsonfile, ident, name), file=sys.stderr)


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
src = read_json(src_jsonfile)
for k in src:
    s='_%s.wav' % ident
    if k.endswith(s):
        newk = k.replace(s, '.wav')
        print('Processing %s -> %s...' % (k, newk), file=sys.stderr)
        tag[newk] = src[k]
        #command = ['/bin/cp', '%s/%s.embedding.npy' % (src_embdir, k), '%s/%s.embedding.npy' % (tag_embdir, newk)]
        command = ['/usr/bin/ln', '-s', '%s/%s.embedding.npy' % (src_embdir, k), '%s/%s.embedding.npy' % (tag_embdir, newk)]
        try:
            res = subprocess.run(command, stdout=sys.stdin, stderr=sys.stderr)
        except Exception as e:
            print(e)
            print('Cannot execute the command %s !' % command, file=sys.stderr)
        
write_json(tag_jsonfile, tag)

