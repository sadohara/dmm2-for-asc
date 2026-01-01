import sys
import filter_signals3

#srcdir=sys.argv[1]
ftag=sys.argv[1]
otag=sys.argv[2]
tagdir=sys.argv[3]
idfthr=float(sys.argv[4])
tfthr=float(sys.argv[5])
srcdirs = []
for n in range(len(sys.argv)-6):
    srcdirs.append(sys.argv[n+6])

print('tag_for_comp_filter=%s, tag_for_filter:%s, tagdir=%s, idfthr=%f, tfthr=%f, srcdirs=%s' % (ftag, otag, tagdir, idfthr, tfthr, ','.join(srcdirs)))

filter_signals3.filter_signals_from_jsonfile_with_dfratio_and_tfratio(srcdirs, ftag, tagdir, otag=otag, idfthr=idfthr, tfthr=tfthr, verbose=1)

