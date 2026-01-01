import csv
import re
import numpy as np
import matplotlib.pyplot as plt
import glob


def readfloattsv(filename):
    with open(filename, 'r') as file:
        reader = csv.reader(file, delimiter='\t')
        data = [] 
        for vs in reader:
            x = []
            for v in vs:
                x = x.append(float(v))
            data = data.append(x)
    return data

def readfloatxsv(filename):
    with open(filename, 'r') as file:
        data = [] 
        line = file.readline()
        while line:
            line = line.strip('\n')
            #print(line)
            vs = re.split('[, \t]', line)
            x = [] 
            #print(vs)
            for v in vs:
                x.append(float(v))
            data.append(x)
            line = file.readline()
    return data


def read_result(filename):
    res = {}
    with open(filename, 'r') as f:
        line = f.readline()
        while line:
            line = line.strip('\n')
            vs = line.split('\t')
            key = vs.pop(0)
            vlist = []
            for v in vs:
                vlist.append(float(v))
            res[key] = vlist
            line = f.readline()
    return res

def extract_scores(ress, score, idxs=None):
    scores = []
    for e in ress:
        if idxs is None:
            scores.append(e[score][:][0])
        else:
            scores.append(e[score][idxs][0])
    return scores

def extract_stds(ress, score, idxs=None):
    scores = []
    for e in ress:
        if idxs is None:
            scores.append(e[score][:][1])
        else:
            scores.append(e[score][idxs][1])
    return scores

def extract_samples(ress, score, idxs=None):
    scores = []
    for e in ress:
        if idxs is None:
            scores.append(e[score][:][2])
        else:
            scores.append(e[score][idxs][2])
    return scores



default_anchor_spec=(1,0)
default_location_spec='lower right'
default_font_size=10

def showone(results, metric, title, labels, anchor, loc, colors=None, fontsize=default_font_size, markers=None, linestyles=None, xlim=None, ylim=None, ks=None):
    plt.title(title)
    #print('n=%d, anchor=%s, loc=%s' % (n, anchor, loc))
    for i in range(len(results)):
        c = None
        if isinstance(colors, list):
            c = colors[i]
        m = None
        if isinstance(markers, list):
            m = markers[i]
        s = None
        if isinstance(linestyles, list):
            s = linestyles[i]
        if ks is None:
            xs = results[i]['K']
            ys = results[i][metric]
        else:
            xs = []
            ys = []
            for k in ks:
                for j in range(len(results[i]['K'])):
                    if results[i]['K'][j] == k:
                        xs.append(results[i]['K'][j])
                        ys.append(results[i][metric][j])
            if len(xs) < 2:
                xs = results[i]['K']
                ys = results[i][metric]

        plt.plot(xs, ys, color=c, marker=m, linestyle=s, label=labels[i])
#        if colors is None:
#            plt.plot(results[i][:,0], results[i][:,n], label=labels[i])
#        else:
#            #print('color=%s' % colors[i])
#            plt.plot(results[i][:,0], results[i][:,n], color=colors[i], label=labels[i])
    plt.xlim(xlim)
    plt.ylim(ylim)
    if not ((anchor is None) or (loc is None)):
        plt.legend(bbox_to_anchor=anchor,loc=loc, borderaxespad=1, fontsize=fontsize)

def extract_scores_from_result(result):
    scores = {}
    scores['accuracy'] = result[:,4].tolist()
    scores['accuracy_std'] = result[:,5].tolist()
#    scores['AMI'] = result[:,16].tolist()
#    scores['AMI_std'] = result[:,17].tolist()
#    scores['ARI'] = result[:,18].tolist()
#    scores['ARI_std'] = result[:,19].tolist()
    scores['F1'] = result[:,10].tolist()
    scores['F1_std'] = result[:,11].tolist()
    scores['precision'] = result[:,6].tolist()
    scores['precision_std'] = result[:,7].tolist()
    scores['recall'] = result[:,8].tolist()
    scores['recall_std'] = result[:,9].tolist()
#    scores['NMI'] = result[:,14].tolist()
#    scores['NMI_std'] = result[:,15].tolist()
    scores['topics_std'] = result[:,3].tolist()
    scores['topics'] = result[:,2].tolist()
    scores['num_samples'] = result[:,1].tolist()
    scores['K'] = result[:,0].tolist()
#    scores['top1acc'] = result[:,20].tolist()
#    scores['top1acc_std'] = result[:,21].tolist()
#    scores['mAP'] = result[:,22].tolist()
#    scores['mAP_std'] = result[:,23].tolist()
#    scores['AUCROC'] = result[:,24].tolist()
#    scores['AUCROC_std'] = result[:,25].tolist()
#    scores['dPrime'] = result[:,26].tolist()
#    scores['dPrime_std'] = result[:,27].tolist()
#    #print(result.shape)
#    if result.shape[1] >= 28:
#        scores['MI'] = result[:,28].tolist()
#        scores['MI_std'] = result[:,29].tolist()
#        scores['MI_Train'] = result[:,30].tolist()
#        scores['MI_Train_std'] = result[:,31].tolist()

    return scores

def read_results(filename):
    lst = readfloatxsv(filename)
    return extract_scores_from_result(np.array(lst))

def showall_sub(ts, results, labels, legendspecs=None, colorspecs=None, markerspecs=None, linestylespecs=None, xlim=None, ylim=None, figsize=(10,8)):
    anchor_specs = []
    location_specs = []
    if isinstance(legendspecs, list) and len(legendspecs) == len(ts):
        for i in range(len(legendspecs)):
            if legendspecs[i] is None:
                anchor_specs.append(None)
                location_specs.append(None)
            elif not isinstance(legendspecs[i], tuple):
                anchor_specs.append(default_anchor_spec)
                location_specs.append(default_location_spec)
            else:
                if isinstance(legendspecs[i][0], tuple):
                    anchor_specs.append(legendspecs[i][0])
                else:
                    anchor_specs.append(default_anchor_spec)
                location_specs.append(legendspecs[i][1])
    else:
        for i in range(len(ts)):
            anchor_specs.append(default_anchor_spec)
            location_specs.append(default_location_spec)
            
    xlim_specs = []
    if isinstance(xlim, list) and len(xlim) == len(ts):
        for i in range(len(xlim)):
            xlim_specs.append(xlim[i])
    else:
        for i in range(len(ts)):
            xlim_specs.append(None)

    ylim_specs = []
    if isinstance(ylim, list) and len(ylim) == len(ts):
        for i in range(len(ylim)):
            ylim_specs.append(ylim[i])
    else:
        for i in range(len(ts)):
            ylim_specs.append(None)

            
    fig = plt.figure(figsize=figsize)
    for n in range(len(ts)):
        #if n < 3:
        #    plt.subplot(4,4,n+1)
        #else:
        #    plt.subplot(4,4,n+2)
        plt.subplot(3,4, n+1)
        showone(results, ts[n], ts[n], labels, anchor_specs[n], location_specs[n], colors=colorspecs, markers=markerspecs, linestyles=linestylespecs, xlim=xlim_specs[n], ylim=ylim_specs[n])

    plt.tight_layout()
    plt.show()
    return fig

def showall(results, labels, legendspecs=None, colorspecs=None, markerspecs=None, linestylespecs=None, xlim=None, ylim=None, figsize=(10,8)):
    ts = ['NMI', 'AMI', 'ARI', 'accuracy', 'F1', 'precision', 'recall', 'topics', 'top1acc', 'mAP', 'AUCROC', 'dPrime']
    return showall_sub(ts, results, labels, legendspecs, colorspecs, markerspecs, linestylespecs, xlim, ylim, figsize)

def showall_with_MI(results, labels, legendspecs=None, colorspecs=None, markerspecs=None, linestylespecs=None, xlim=None, ylim=None, figsize=(10,8)):
    ts = ['MI', 'AMI', 'ARI', 'accuracy', 'F1', 'precision', 'recall', 'topics', 'top1acc', 'mAP', 'AUCROC', 'dPrime']
    return showall_sub(ts, results, labels, legendspecs, colorspecs, markerspecs, linestylespecs, xlim, ylim, figsize)

def showall_with_MI_Train(results, labels, legendspecs=None, colorspecs=None, markerspecs=None, linestylespecs=None, xlim=None, ylim=None, figsize=(10,8)):
    ts = ['MI_Train', 'AMI', 'ARI', 'accuracy', 'F1', 'precision', 'recall', 'topics', 'top1acc', 'mAP', 'AUCROC', 'dPrime']
    return showall_sub(ts, results, labels, legendspecs, colorspecs, markerspecs, linestylespecs, xlim, ylim, figsize)


def drawbars(plt, ylabel, data, colors, labels, ylim=(0,1), title=None, xs=None, ylabelsize=None):
    if xs is None:
        xs = np.arange(len(data))

    plt.bar(xs, data, color=colors)
    for x, y in zip(xs, data):
        plt.text(x, y, '%.5f' % y, ha='center', va='bottom')
    plt.xticks(xs, labels)
    plt.ylabel(ylabel, fontsize=ylabelsize)
    plt.ylim(ylim)
    plt.title(title)
    plt.tight_layout()


def limitK(res, maxK):
    a = dict()
    maxi = -1
    for i in range(len(res['K'])):
        k = res['K'][i]
        if k <= maxK:
            maxi = i
        else:
            break
    if maxi >= 0:
        for k in res.keys():
            a[k] = res[k][0:maxi+1]
    return(a)

def collect4scores(res, K):
    ans = dict()
    ks = res['K']
    j = -1
    for i in range(len(ks)):
        if ks[i] == K:
            j = i
            break
    if j >= 0 and j < len(ks):
        ans['acc'] = res['top1acc'][j]
        ans['mAP'] = res['mAP'][j]
        ans['dprime'] = res['dPrime'][j]
        ans['aucroc'] = res['AUCROC'][j]
        return ans
    return None

def collect_aggregated_scores(res):
    r = dict()
    r["acc"] = res["aggregated_scores"]["test_top1_acc_mean"]
    r["mAP"] = res["aggregated_scores"]["test_mAP_mean"]
    r["dprime"] = res["aggregated_scores"]["test_d_prime_mean"]
    r["aucroc"] = res["aggregated_scores"]["test_aucroc_mean"]
    return r

def collect_score(score, res, models):
    a = []
    for m in models:
        a.append(res[m][score])
    return a

def collect_score_K(score, res, models, Ks):
    a = []
    for i in range(len(models)):
        ss = res[models[i]][score]
        a.append(ss[Ks[i]])
    return a

def drawbars(plt, ylabel, data, colors, labels, ylim=(0,1), title=None, xs=None, ylabelsize=None):
    if xs is None:
        xs = np.arange(len(data))

    plt.bar(xs, data, color=colors)
    for x, y in zip(xs, data):
        plt.text(x, y, '%.5f' % y, ha='center', va='bottom')
    plt.xticks(xs, labels)
    plt.ylabel(ylabel, fontsize=ylabelsize)
    plt.ylim(ylim)
    plt.title(title)
    plt.tight_layout()

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
