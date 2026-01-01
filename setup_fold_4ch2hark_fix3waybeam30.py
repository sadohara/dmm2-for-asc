import os
import sys
import subprocess
import json
import glob

infofile=sys.argv[1]
audiosrcdir=sys.argv[2]
audiotagdir=sys.argv[3]
jsonfile=sys.argv[4]

print('setup_fold_4ch2hark_4ch2hark_fix3waybeam30.py: info:%s src:%s tag:%s json:%s' % (infofile, audiosrcdir, audiotagdir, jsonfile), file=sys.stderr)

labels = dict()
with open(infofile, 'r') as f:
	line = f.readline()
	while line:
		line = line.strip()
		cols = line.split()
		label = cols[1]
		ps = cols[0].split('/')
		filename = ps[-1]
		labels[filename] = [label]
		command=['./4ch2hark_fix3waybeam30.sh', audiosrcdir, audiotagdir, filename]
		print('Making a separated wavfile %s with %s' % (filename, ' '.join(command)), file=sys.stderr)
		try:
    			res = subprocess.run(command, stdout=sys.stderr, stderr=sys.stderr)
		except Exception as e:
    			print('%s\nWarning! Cannot link %s from %s to %s' % (e,filename, audiosrcdir, audiotagdir), file=sys.stderr)

		line = f.readline()

with open(jsonfile, 'w') as f:
	json.dump(labels, f, indent=2)
