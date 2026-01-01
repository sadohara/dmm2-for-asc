import sys

labfile=sys.argv[1]
numfile=sys.argv[2]
offset=float(sys.argv[3])

labels = dict()
with open(labfile, 'r') as f:
	line = f.readline()
	while line:
            line = line.strip()
            cols = line.split()
            labels[cols[1]] = int(cols[0])
            line = f.readline()

with open(numfile, 'r') as f:
        line = f.readline()
        while line:
            line = line.strip()
            cols = line.split('\t')
            assert cols[4] in labels, "%s is unknown!" % cols[4]
            print('%.1f\t%.1f\t%u' % (float(cols[0])+offset, float(cols[1])+offset, labels[cols[4]]))
            line = f.readline()

