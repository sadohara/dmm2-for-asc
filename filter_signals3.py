import sys
import numpy as np
import math
import json
import glob


def read_idxfile(filename):
    print('Reading %s...' % filename, file=sys.stderr)
    with open(filename, 'r') as fd:
        idxs = json.load(fd)
    return idxs

def read_fold(src, tag):
    idxs = []
    filenames = []
    prefixs = []
    if isinstance(src, str):
        src = [src]
        prefixs = ['']
    elif isinstance(src, list):
        for s in src:
            ps = s.split('/')
            prefixs.append('%s.' % ps[-1])
    for i in range(len(src)):
        s = src[i]
        jsons = '%s/fold*.%s.json' % (s, tag)
        for j in glob.glob(jsons):
            idxs.append(read_idxfile(j))
            ps = j.split('/')
            filenames.append('%s%s' % (prefixs[i], ps[-1]))
    if len(src) > 1:
        print(filenames)
    return idxs, filenames

def read_numfile(filename):
    print('Reading %s...' % filename, file=sys.stderr)
    idxs = dict()
    with open(filename, 'r') as fd:
        line = fd.readline()
        while line:
            line = line.strip()
            vs = line.split('\t')
            dn = vs[3] + vs[0]
            ss = [int(s) for s in vs[2].split()]
            idxs[dn] = ss
            line = fd.readline()
    return idxs

def read_foldnum(srcdir):
    idxs = []
    nums = '%s/fold*.num' % (srcdir)
    for n in glob.glob(nums):
        idxs.append(read_numfile(n))
    return idxs


def count_frequency(idxs):
    tf = dict()
    for ix in idxs:
        for d in ix:
            for i in ix[d]:
                if i not in tf:
                    tf[i] = 0
                tf[i] += 1
    tf2 = sorted(tf.items(), key=lambda x:x[1], reverse=True)
    return tf2, tf

def comp_idf(voc, idxs, rawfreq=False):
    idf = dict()
    nd = 0
    for ix in idxs:
        for d in ix:
            nd += 1
            found = dict()
            for i in ix[d]:
                if i not in found:
                    found[i] = 1
                    if i not in idf:
                        idf[i] = 0
                    idf[i] += 1
    if not rawfreq:
        for t in idf:
            idf[t] = math.log2((nd + 1)/(idf[t] + 1))
    idf2 = sorted(idf.items(), key=lambda x:x[1], reverse=True)
    return idf2,idf,nd

def comp_tfidf(d, idf):
    tfidf = dict()
    tf = dict()
    for i in d:
        if i not in tf:
            tf[i] = 0
        tf[i] += 1
    s = 0
    for t in tf:
        s += tf[t]
    for t in tf:
        tfidf[t] = idf[t] * tf[t]/s
    tfidf2 = sorted(tfidf.items(), key=lambda x:x[1], reverse=True)
    return tfidf2, tfidf

def filter_term(folds, idf, acc_tfidf=0.9):
    selected = dict()
    for f in folds:
        for d in f:
            tfidf2, tfidf = comp_tfidf(f[d], idf)
            s = 0
            for v,c in tfidf2:
                s += c
            thr = s * acc_tfidf
            s = 0
            for v,c in tfidf2:
                s += c
                selected[v] = 1
                if s > thr:
                    break
    return selected

def filter_local_tfidf(folds, idf, voc, acc_tfidf=0.9):
    selected = dict()
    for f in folds:
        for d in f:
            tfidf2, tfidf = comp_tfidf(f[d], idf)
            s = 0
            for v,c in tfidf2:
                if v in voc:
                    s += c
            thr = s * acc_tfidf
            s = 0
            for v,c in tfidf2:
                if v in voc:
                    s += c
                    selected[v] = 1
                    if s > thr:
                        break
    return selected



def comp_global_tfidf(tf, idf):
    tfidf = dict()
    for v in tf.keys():
        tfidf[v] = tf[v] * idf[v]
    tfidf2 = sorted(tfidf.items(), key=lambda x:x[1], reverse=True)
    return tfidf2, tfidf

def comp_local_tf(tf, ridf):
    ltf = dict()
    for v in tf.keys():
        ltf[v] = tf[v] / ridf[v]
    ltf2 = sorted(ltf.items(), key=lambda x:x[1], reverse=True)
    return ltf2, ltf

def filter_global_tfidf(gtfidf2, voc, ratio=0.9):
    #print('Filter with gtfidf ratio = %f' % ratio)\n",
    fil = dict()
    sel = dict()
    tot = 0.0
    for v,c in gtfidf2:
        if v == -1:
            continue
        assert c > 0, "found negative value %f for %s!" % (c, v)
        if v in voc:
            tot += c

    s = 0.0
    for v,c in gtfidf2:
        if v not in voc:
            fil[v] = 1
            continue
        if v == -1:
            continue
        s += c
        if s/tot <= ratio:
            sel[v] = 1
        else:
            fil[v] = 1
    sel[-1] = 1
    return fil, sel

def filter_local_tf(ltf2, voc, ratio=0.9):
    #print('Filter with gtfidf ratio = %f' % ratio)\n",
    fil = dict()
    sel = dict()
    tot = 0.0
    for v,c in ltf2:
        assert c > 0, "found negative value %f for %s!" % (c, v)
        if v in voc:
            tot += c
    s = 0.0
    for v,c in ltf2:
        if v not in voc:
            fil[v] = 1
            continue
        s += c
        if s/tot <= ratio:
            sel[v] = 1
        else:
            fil[v] = 1
    return fil, sel

def output_json(folds, selected, outdir, filenames):
    for fi in range(len(folds)):
        f = folds[fi]
        idxs = dict()
        for k in f:
            lst = []
            for i in f[k]:
                j = i
                if i not in selected:
                    j = -1
                lst.append(j)
            idxs[k] = lst
        jsonfile = '%s/%s' % (outdir,filenames[fi])
        print('Writting %s...' % jsonfile, file=sys.stderr)
        with open(jsonfile, 'w') as fd:
            json.dump(idxs, fd, indent=2)

def filter_signals_from_jsonfile(srcdir, tag, outdir, tfidfthr=0.9, tfthr=None, verbose=0):
    folds, filenames = read_fold(srcdir, tag)
    tf2, tf = count_frequency(folds)
    vocab = [v for (v,c) in tf2]
    idf2, idf, nd = comp_idf(vocab, folds)
    sel0 = filter_term(folds, idf, acc_tfidf=tfidfthr)
    sel = dict()
    if type(tfthr) is int:
        for v in sel0:
            if tf[v] >= tfthr:
                sel[v] = 1
                if verbose > 1:
                    print('%s:%u >= %u' % (v, tf[v], tfthr), file=sys.stderr)
    else:
        sel = sel0
    if verbose > 0:
        print('#voc=%u, #sel=%u, #doc=%u, tfidfthr=%.3f, tfthr=%u' % (len(vocab), len(sel.keys()), nd, tfidfthr, tfthr), file=sys.stderr)
    output_json(folds, sel, outdir, filenames)
    return tf, idf, sel



def filter_signals_from_jsonfile_with_dfratio_and_tfratio(srcdir, tag, outdir, otag=None, idfthr=0.9, tfthr=0.9, verbose=0):
    folds, filenames = read_fold(srcdir, tag)
    tf2, tf = count_frequency(folds)

    vocab = [v for (v,c) in tf2]
    idf2, idf, nd = comp_idf(vocab, folds, rawfreq=True) 
    sel0 = dict()
    for v,c in idf2:
        if c/nd <= idfthr:
            sel0[v] = 1
            if verbose > 1:
                print('%s:%u %.1f <= %.1f' % (v, c, c/nd, idfthr), file=sys.stderr)
    
    if not -1 in sel0:
        sel0[-1] = 1

    occ = 0
    occ0 = 0
    for v,c in tf2:
        if v == -1:
            continue
        occ0 += c
        if v in sel0:
            occ += c
    sel = dict()
    acc = 0
    for v,c in tf2:
        if v != -1 and v in sel0:
            acc += c
            if acc / occ <= tfthr:
                sel[v] = 1
                if verbose > 1:
                    print('%s:%u %u / %u = %.3f <= %u' % (v, tf[v], acc, occ, acc/occ, tfthr), file=sys.stderr)
            else:
                break
    sel[-1] = 1

    if verbose > 0:
        print('#voc=%u, #sel=%u(%u), #doc=%u, #occ=%u/%u(%.3f), idfthr=%.3f, tfthr=%.3f' % (len(vocab), len(sel.keys()), len(sel0.keys()), nd, occ, occ0, occ/occ0, idfthr, tfthr), file=sys.stderr)

    if not otag is None:
        folds, filenames = read_fold(srcdir, otag)
    output_json(folds, sel, outdir, filenames)
    return tf, idf, sel

def filter_signals_from_jsonfile_with_dfratio_and_tfidfratio(srcdir, tag, outdir, otag=None, idfthr=0.9, tfidfthr=0.9, verbose=0):
    folds, filenames = read_fold(srcdir, tag)
    tf2, tf = count_frequency(folds)

    vocab = [v for (v,c) in tf2]
    ridf2, ridf, nd = comp_idf(vocab, folds, rawfreq=True)
    sel0 = dict()
    for v,c in ridf2:
        if c/nd <= idfthr:
            sel0[v] = 1
            if verbose > 1:
                print('%s:%u %.1f <= %.1f' % (v, c, c/nd, idfthr), file=sys.stderr)

    if not -1 in sel0:
        sel0[-1] = 1

    occ = 0
    occ0 = 0
    for v,c in tf2:
        if v == -1:
            continue
        occ0 += c
        if v in sel0:
            occ += c

    idf2, idf, nd = comp_idf(vocab, folds, rawfreq=False)
    gtfidf2, gtfidf = comp_global_tfidf(tf, idf)
    fil, sel = filter_global_tfidf(gtfidf2, sel0, ratio=tfidfthr) 

    if verbose > 0:
        print('#voc=%u, #sel=%u(%u), #doc=%u, #occ=%u/%u(%.3f), idfthr=%.3f, tfidfthr=%.3f' % (len(vocab), len(sel.keys()), len(sel0.keys()), nd, occ, occ0, occ/occ0, idfthr, tfidfthr), file=sys.stderr)

    if not otag is None:
        folds, filenames = read_fold(srcdir, otag)
    output_json(folds, sel, outdir, filenames)
    return tf, idf, sel

def filter_signals_from_jsonfile_with_dfratio_and_localtfratio(srcdir, tag, outdir, idfthr=0.9, tfthr=0.9, verbose=0):
    folds, filenames = read_fold(srcdir, tag)
    tf2, tf = count_frequency(folds)

    vocab = [v for (v,c) in tf2]
    ridf2, ridf, nd = comp_idf(vocab, folds, rawfreq=True)
    sel0 = dict()
    for v,c in ridf2:
        if c/nd <= idfthr:
            sel0[v] = 1
            if verbose > 1:
                print('%s:%u %.1f <= %.1f' % (v, c, c/nd, idfthr), file=sys.stderr)

    ltf2, ltf = comp_local_tf(tf, ridf)
    fil, sel = filter_local_tf(ltf2, sel0, ratio=tfthr)

    if verbose > 0:
        print('#voc=%u, #sel=%u, #doc=%u, idfthr=%.3f, tfthr=%.3f' % (len(vocab), len(sel.keys()), nd, idfthr, tfthr), file=sys.stderr)

    output_json(folds, sel, outdir, filenames)
    return ltf, sel

def filter_signals_from_jsonfile_with_dfratio_and_localtfidfratio(srcdir, tag, outdir, dfthr=0.9, tfidfthr=0.9, verbose=0):
    folds, filenames = read_fold(srcdir, tag)
    tf2, tf = count_frequency(folds)

    vocab = [v for (v,c) in tf2]
    ridf2, ridf, nd = comp_idf(vocab, folds, rawfreq=True)
    sel0 = dict()
    for v,c in ridf2:
        if c/nd <= dfthr:
            sel0[v] = 1
            if verbose > 1:
                print('%s:%u %.1f <= %.1f' % (v, c, c/nd, dfthr), file=sys.stderr)

    idf2, idf, nd = comp_idf(vocab, folds, rawfreq=False)
    sel = filter_local_tfidf(folds, idf, sel0, acc_tfidf=tfidfthr)

    if verbose > 0:
        print('#voc=%u, #sel=%u, #doc=%u, dfthr=%.3f, tfidfthr=%.3f' % (len(vocab), len(sel.keys()), nd, dfthr, tfidfthr), file=sys.stderr)

    output_json(folds, sel, outdir, filenames)
    return sel

