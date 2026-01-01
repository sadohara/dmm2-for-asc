import matplotlib.pyplot as plt


def plot_count(name, counter, title, xlim=(0,50)):
    min_y = 1.0
    max_x = 0.0
    for i in range(len(counter)):
        xs = list(range(len(counter[i])))
        if xs[-1] > max_x:
            max_x = xs[-1]
        if counter[i][-1] < min_y:
            min_y = counter[i][-1]
        plt.plot(xs, counter[i], label=name[i])
    plt.title(title)
    plt.yscale('log')
    plt.ylim((min_y, 1.0))
    plt.xlim(xlim)

def read_idx(filename):
    count = []
    dnum = 0
    maxi = 0
    with open(filename, 'r') as f:
        line = f.readline()
        while line:
            line = line.strip()
            vs = line.split(' ')
            lp = []
            for v in vs:
                i = int(v)
                lp.append(i)
                if i > maxi:
                    maxi = i
            count.append(lp)
            dnum += 1
            line = f.readline()
    return count, dnum, maxi

def read_idxs(template):
    count = []
    dnum = 0
    maxi = 0
    for f in glob.glob(template):
        print('> Reading %s...' % f)
        c, d, m = read_idx(f)
        print('< Read %u lines and found the maximum index %u' % (d, m))
        dnum += d
        if m > maxi:
            maxi = m
        count.extend(c)
    print('Read %u lines and found the maximum index %u' % (dnum, maxi))
    cm = np.zeros((dnum, maxi+1), dtype=np.int64)
    m = 0
    for d in count:
        for i in d:
            cm[m][i] += 1
        m += 1
    return cm

# for each w in idxs, compute [P(0), P(1), ..., P(x), ...] where P(x) is the probability such that w appears exactly x times in a document
def collect_probs(d2w, idxs):
    probs = []
    dnum = d2w.shape[0]
    for w in idxs:
        ps = []
        for i in range(dnum):
            c = d2w[i][w]
            if len(ps) < c + 1:
                for j in range(len(ps), c+1):
                    ps.append(0)
            ps[c] += 1
        for j in range(len(ps)):
            ps[j] /= dnum
        probs.append(ps)
    return(probs)

# compute [A(0), A(1), ..., A(x), ...] where A(x) is the average of P(x) for all words
def comp_average(probs):
    prob = []
    lngt = []
    for i in range(len(probs)):
        ps = probs[i]
        for j in range(len(ps)):
            if len(prob) < j + 1:
                for k in range(len(prob), j+1):
                    prob.append(0)
                    lngt.append(0)
            prob[j] += ps[j]
            lngt[j] += 1
    for j in range(len(prob)):
        prob[j] /= lngt[j]
    return prob

def show_freqprob(d2w, topi, xlim=None, figsize=(8,5)):
    print(d2w.shape)
    wfreq = np.sum(d2w, axis=0)
    print(wfreq.shape)
    idxs = np.argsort(wfreq)
    idxs_sorted_descending_order = idxs[::-1]
    wfreq_sorted_descending_order = wfreq[idxs_sorted_descending_order]
    avg = np.mean(wfreq_sorted_descending_order)
    avgi = 0
    for i in range(len(wfreq_sorted_descending_order)):
        if wfreq_sorted_descending_order[i] < avg:
            avgi = i
            break
    plt.plot(list(range(len(wfreq_sorted_descending_order))), wfreq_sorted_descending_order)
    plt.plot([0, len(wfreq_sorted_descending_order)], [wfreq_sorted_descending_order[topi], wfreq_sorted_descending_order[topi]])
    plt.text(len(wfreq_sorted_descending_order), wfreq_sorted_descending_order[topi], '%.3f' % wfreq_sorted_descending_order[topi], ha='right', va='bottom')
    plt.plot([0, len(wfreq_sorted_descending_order)], [avg, avg])
    plt.plot([avgi], [wfreq_sorted_descending_order[avgi]], marker='*')
    plt.text(avgi, wfreq_sorted_descending_order[avgi], '(%d, %d)' % (avgi, wfreq_sorted_descending_order[avgi]), ha='left', va='bottom')
    plt.text(len(wfreq_sorted_descending_order), avg, '%.3f' % avg, ha='right', va='bottom')
    plt.show()

    wfreq_top = idxs_sorted_descending_order[0:topi]
    wfreq_average = idxs_sorted_descending_order[topi:avgi]
    wfreq_rare = idxs_sorted_descending_order[avgi:]
    print('top%u=%u, average%u=%u, rare=%u' % (topi, len(wfreq_top), avgi - topi, len(wfreq_average), len(wfreq_rare)))
    prob_top = collect_probs(d2w, wfreq_top)
    avrg_top = comp_average(prob_top)
    prob_average = collect_probs(d2w, wfreq_average)
    avrg_average = comp_average(prob_average)
    prob_rare = collect_probs(d2w, wfreq_rare)
    avrg_rare = comp_average(prob_rare)

    fig = plt.figure(figsize=figsize)
    plot_count(['top%u'%topi, 'average%u'%(avgi - topi), 'rare%u'%(len(wfreq_rare))], [avrg_top, avrg_average, avrg_rare], '', xlim=xlim)
    plt.tight_layout()
    plt.legend()
    return fig
