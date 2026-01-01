import sys
import os
import json
import glob
import numpy as np
import torch
import torchaudio
from audiolm_pytorch import EncodecWrapper
import torch.nn.functional as F

wavdir=sys.argv[1]
tagdir=sys.argv[2]
tag=sys.argv[3]
folds=sys.argv[4]
print('soundstreem_encode2_aux.py: wavdir=%s, tagdir=%s, tag=%s, folds=%s' % (wavdir, tagdir, tag, folds))
embsuffix = 'embedding.npy'

resampler = None
audio_codec = EncodecWrapper().cuda()
predefined_rate = 24000

def load(f):
    global resampler
    wav, srate = torchaudio.load(f)
    assert srate == 16000, "Unexpected wavfile!"

    if resampler is None:
        print('create a resampler converting from %u to %u...' % (srate, predefined_rate))
        resampler = torchaudio.transforms.Resample(srate, predefined_rate, dtype=wav.dtype)
    wavform = resampler(wav)
    return wavform 

def encode(codec, wav_dir, fold, tagdir, tag='idx'):
    jsonfile = '%s/%s.json' % (wav_dir, fold)
    idxfile = '%s/%s.%s.json' % (tagdir, fold, tag)
    if os.path.isfile(idxfile):
        print('Skip creating %s...' % idxfile)
        return
    print('Reading %s and creating %s...' % (jsonfile, idxfile))
    files = json.load(open(jsonfile))
    n = 0
    codes = dict()
    for f in files:
        stem = os.path.splitext(f)[0]
        for wavfile in glob.glob('%s/16000/%s/%s_*.wav' % (wav_dir, fold, stem)):
            n += 1
            w = os.path.basename(wavfile)
            #wavfile = '%s/16000/%s/%s' % (wav_dir, fold, w)
            embfile = '%s/%s/%s.%s' % (tagdir, fold, w, embsuffix)
            print(' %05u: Reading %s...' % (n, wavfile)) 
            wavform = load(wavfile)
            embs, idxs, _ = codec(wavform.cuda(), return_encoded=True)
            codes[w] = idxs.tolist()[0]
            print(' %05u: Creating %s...' % (n, embfile)) 
            np.save(embfile, embs[0].to('cpu').detach().numpy())
    with open(idxfile, 'w') as fd:
        json.dump(codes, fd, indent=2)
    print('%s/%s: #e=%u' % (wav_dir, fold, n))




for fold in folds.split(','):
    encode(audio_codec, wavdir, fold, tagdir, tag)


