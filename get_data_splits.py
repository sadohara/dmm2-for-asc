import sys
import subprocess
import data_splits

out_prefix = sys.argv[1]
way_of_split = sys.argv[2]
folds = []
for i in range(len(sys.argv) - 3):
    folds.append(sys.argv[i+3])

print('out_prefix=%s, way_of_split=%s, folds=%s' % (out_prefix, way_of_split, ' '.join(folds)), file=sys.stderr)

dsplits = data_splits.split_data(way_of_split, folds)
for i, split in enumerate(dsplits):
    outdir = '%s%s' % (out_prefix, split['outdir'])
    command = ['/bin/mkdir', '-p', outdir]
    try:
        res = subprocess.run(command, stdout=sys.stdin, stderr=sys.stderr)
    except Exception as e:
        print(e)
        print('Cannot create %s!' % outdir, file=sys.stderr)

    outfile = '%s/data_splits.txt' % outdir
    with open(outfile, 'w') as fp:
        print('%s' % (' '.join(split['train'])), file=fp)
        print('%s' % (' '.join(split['valid'])), file=fp)
        print('%s' % (' '.join(split['test'])), file=fp)

