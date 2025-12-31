# dmm2-for-asc

## Paper
Ken Sadohara and Natsuki Miyata, "Activity Recognition from Daily Life Sounds Using Unsupervised Learning with Dirichlet Multinomial Mixture Models", submitted to Sensors.

The plots in the paper and the data used to create them are included in `00000Results.ipynb`.

## Software and Data
The software and data in this repository may only be used for the purpose of verifying the reproducibility of the paper.

Notice that we have confirmed that the output of 'dmm2' differs depending on the dynamic linked libraries. 

Results in the paper is obtained in the following environment.

```
> cat /etc/os-release
NAME="Ubuntu
VERSION="20.04.6 LTS (Focal Fossa)
ID=ubunt
ID_LIKE=debia
PRETTY_NAME="Ubuntu 20.04.6 LTS
VERSION_ID="20.04
HOME_URL="https://www.ubuntu.com/"
SUPPORT_URL="https://help.ubuntu.com/"
BUG_REPORT_URL="https://bugs.launchpad.net/ubuntu/"
PRIVACY_POLICY_URL="https://www.ubuntu.com/legal/terms-and-policies/privacy-policy"
VERSION_CODENAME=focal
UBUNTU_CODENAME=focal

> ldd dmm2
linux-vdso.so.1 (0x00007ffcbb5ba000)
libm.so.6 => /lib/x86_64-linux-gnu/libm.so.6 (0x00007f2d94a5a000)
libc.so.6 => /lib/x86_64-linux-gnu/libc.so.6 (0x00007f2d94868000)
/lib64/ld-linux-x86-64.so.2 (0x00007f2d94bd1000)

> ls -l /lib/x86_64-linux-gnu/libm.so.6
lrwxrwxrwx 1 root root 12  5月 26  2025 /lib/x86_64-linux-gnu//libm.so.6 -> libm-2.31.so

> ls -l /lib/x86_64-linux-gnu/libc.so.6
lrwxrwxrwx 1 root root 12  5月 26  2025 /lib/x86_64-linux-gnu/libc.so.6 -> libc-2.31.so
```

### Environment for EnCodec
```
> conda list
# packages in environment at /home/sadohara/miniconda3/envs/audiolm310:
#
# Name                    Version                   Build  Channel
_libgcc_mutex             0.1                 conda_forge    conda-forge
_openmp_mutex             4.5                       2_gnu    conda-forge
accelerate                0.28.0                   pypi_0    pypi
antlr4-python3-runtime    4.8                      pypi_0    pypi
appdirs                   1.4.4                    pypi_0    pypi
audiolm-pytorch           2.0.7                    pypi_0    pypi
beartype                  0.17.2                   pypi_0    pypi
bitarray                  2.9.2                    pypi_0    pypi
bzip2                     1.0.8                hd590300_5    conda-forge
ca-certificates           2024.2.2             hbcca054_0    conda-forge
certifi                   2024.2.2                 pypi_0    pypi
cffi                      1.16.0                   pypi_0    pypi
charset-normalizer        3.3.2                    pypi_0    pypi
click                     8.1.7                    pypi_0    pypi
colorama                  0.4.6                    pypi_0    pypi
cython                    3.0.9                    pypi_0    pypi
docker-pycreds            0.4.0                    pypi_0    pypi
einops                    0.7.0                    pypi_0    pypi
einx                      0.1.3                    pypi_0    pypi
ema-pytorch               0.4.3                    pypi_0    pypi
encodec                   0.1.1                    pypi_0    pypi
fairseq                   0.12.2                   pypi_0    pypi
filelock                  3.13.3                   pypi_0    pypi
frozendict                2.4.0                    pypi_0    pypi
fsspec                    2024.3.1                 pypi_0    pypi
gateloop-transformer      0.2.4                    pypi_0    pypi
gitdb                     4.0.11                   pypi_0    pypi
gitpython                 3.1.42                   pypi_0    pypi
huggingface-hub           0.22.0                   pypi_0    pypi
hydra-core                1.0.7                    pypi_0    pypi
idna                      3.6                      pypi_0    pypi
jinja2                    3.1.3                    pypi_0    pypi
joblib                    1.3.2                    pypi_0    pypi
ld_impl_linux-64          2.40                 h41732ed_0    conda-forge
libffi                    3.4.2                h7f98852_5    conda-forge
libgcc-ng                 13.2.0               h807b86a_5    conda-forge
libgomp                   13.2.0               h807b86a_5    conda-forge
libnsl                    2.0.1                hd590300_0    conda-forge
libsqlite                 3.45.2               h2797004_0    conda-forge
libuuid                   2.38.1               h0b41bf4_0    conda-forge
libxcrypt                 4.4.36               hd590300_1    conda-forge
libzlib                   1.2.13               hd590300_5    conda-forge
local-attention           1.9.0                    pypi_0    pypi
lxml                      5.1.0                    pypi_0    pypi
markupsafe                2.1.5                    pypi_0    pypi
mpmath                    1.3.0                    pypi_0    pypi
ncurses                   6.4.20240210         h59595ed_0    conda-forge
networkx                  3.2.1                    pypi_0    pypi
numpy                     1.26.4                   pypi_0    pypi
nvidia-cublas-cu12        12.1.3.1                 pypi_0    pypi
nvidia-cuda-cupti-cu12    12.1.105                 pypi_0    pypi
nvidia-cuda-nvrtc-cu12    12.1.105                 pypi_0    pypi
nvidia-cuda-runtime-cu12  12.1.105                 pypi_0    pypi
nvidia-cudnn-cu12         8.9.2.26                 pypi_0    pypi
nvidia-cufft-cu12         11.0.2.54                pypi_0    pypi
nvidia-curand-cu12        10.3.2.106               pypi_0    pypi
nvidia-cusolver-cu12      11.4.5.107               pypi_0    pypi
nvidia-cusparse-cu12      12.1.0.106               pypi_0    pypi
nvidia-nccl-cu12          2.19.3                   pypi_0    pypi
nvidia-nvjitlink-cu12     12.4.99                  pypi_0    pypi
nvidia-nvtx-cu12          12.1.105                 pypi_0    pypi
omegaconf                 2.0.6                    pypi_0    pypi
openssl                   3.2.1                hd590300_1    conda-forge
packaging                 24.0                     pypi_0    pypi
pip                       24.0               pyhd8ed1ab_0    conda-forge
portalocker               2.8.2                    pypi_0    pypi
protobuf                  4.25.3                   pypi_0    pypi
psutil                    5.9.8                    pypi_0    pypi
pycparser                 2.21                     pypi_0    pypi
python                    3.10.14         hd12c33a_0_cpython    conda-forge
pytorch-warmup            0.1.1                    pypi_0    pypi
pyyaml                    6.0.1                    pypi_0    pypi
readline                  8.2                  h8228510_1    conda-forge
regex                     2023.12.25               pypi_0    pypi
requests                  2.31.0                   pypi_0    pypi
rotary-embedding-torch    0.5.3                    pypi_0    pypi
sacrebleu                 2.4.1                    pypi_0    pypi
safetensors               0.4.2                    pypi_0    pypi
scikit-learn              1.4.1.post1              pypi_0    pypi
scipy                     1.12.0                   pypi_0    pypi
sentencepiece             0.2.0                    pypi_0    pypi
sentry-sdk                1.43.0                   pypi_0    pypi
setproctitle              1.3.3                    pypi_0    pypi
setuptools                69.2.0             pyhd8ed1ab_0    conda-forge
six                       1.16.0                   pypi_0    pypi
smmap                     5.0.1                    pypi_0    pypi
sox                       1.5.0                    pypi_0    pypi
sympy                     1.12                     pypi_0    pypi
tabulate                  0.9.0                    pypi_0    pypi
threadpoolctl             3.4.0                    pypi_0    pypi
tk                        8.6.13          noxft_h4845f30_101    conda-forge
tokenizers                0.15.2                   pypi_0    pypi
torch                     2.2.1                    pypi_0    pypi
torchaudio                2.2.1                    pypi_0    pypi
tqdm                      4.66.2                   pypi_0    pypi
transformers              4.39.1                   pypi_0    pypi
triton                    2.2.0                    pypi_0    pypi
typing-extensions         4.10.0                   pypi_0    pypi
tzdata                    2024a                h0c530f3_0    conda-forge
urllib3                   2.2.1                    pypi_0    pypi
vector-quantize-pytorch   1.14.5                   pypi_0    pypi
wandb                     0.16.5                   pypi_0    pypi
wheel                     0.43.0             pyhd8ed1ab_0    conda-forge
xz                        5.2.6                h166bdaf_0    conda-forge
```

### Environment for Evaluation
```
# packages in environment at /home/sadohara/miniconda3/envs/mini38:
#
# Name                    Version                   Build  Channel
_libgcc_mutex             0.1                 conda_forge    conda-forge
_openmp_mutex             4.5                       2_gnu    conda-forge
absl-py                   2.1.0                    pypi_0    pypi
aiohttp                   3.9.3                    pypi_0    pypi
aiosignal                 1.3.1                    pypi_0    pypi
astunparse                1.6.3                    pypi_0    pypi
async-timeout             4.0.3                    pypi_0    pypi
attrs                     23.2.0                   pypi_0    pypi
audioread                 3.0.1                    pypi_0    pypi
boto3                     1.34.56                  pypi_0    pypi
botocore                  1.34.56                  pypi_0    pypi
bzip2                     1.0.8                hd590300_5    conda-forge
ca-certificates           2024.2.2             hbcca054_0    conda-forge
cachetools                5.3.3                    pypi_0    pypi
certifi                   2024.2.2                 pypi_0    pypi
cffi                      1.16.0                   pypi_0    pypi
cfn-flip                  1.3.0                    pypi_0    pypi
charset-normalizer        3.3.2                    pypi_0    pypi
chevron                   0.14.0                   pypi_0    pypi
click                     8.1.7                    pypi_0    pypi
contextlib2               21.6.0                   pypi_0    pypi
contourpy                 1.1.1                    pypi_0    pypi
cycler                    0.12.1                   pypi_0    pypi
dcase-util                0.2.20                   pypi_0    pypi
decorator                 5.1.1                    pypi_0    pypi
filelock                  3.13.1                   pypi_0    pypi
flatbuffers               2.0.7                    pypi_0    pypi
fonttools                 4.49.0                   pypi_0    pypi
frozenlist                1.4.1                    pypi_0    pypi
fsspec                    2024.2.0                 pypi_0    pypi
future                    1.0.0                    pypi_0    pypi
gast                      0.4.0                    pypi_0    pypi
google-api-core           2.17.1                   pypi_0    pypi
google-api-python-client  2.121.0                  pypi_0    pypi
google-auth               2.28.1                   pypi_0    pypi
google-auth-httplib2      0.2.0                    pypi_0    pypi
google-auth-oauthlib      1.0.0                    pypi_0    pypi
google-cloud-core         2.4.1                    pypi_0    pypi
google-cloud-storage      2.15.0                   pypi_0    pypi
google-crc32c             1.5.0                    pypi_0    pypi
google-pasta              0.2.0                    pypi_0    pypi
google-resumable-media    2.7.0                    pypi_0    pypi
googleapis-common-protos  1.62.0                   pypi_0    pypi
grpcio                    1.62.0                   pypi_0    pypi
h5py                      3.10.0                   pypi_0    pypi
hearbaseline              2021.1.1                 pypi_0    pypi
heareval                  2021.1.3                 pypi_0    pypi
httplib2                  0.22.0                   pypi_0    pypi
huggingface-hub           0.21.3                   pypi_0    pypi
hyperpyyaml               1.2.2                    pypi_0    pypi
idna                      3.6                      pypi_0    pypi
importlib-metadata        7.0.1                    pypi_0    pypi
intervaltree              3.1.0                    pypi_0    pypi
jinja2                    3.1.3                    pypi_0    pypi
jmespath                  1.0.1                    pypi_0    pypi
joblib                    1.3.2                    pypi_0    pypi
julius                    0.2.7                    pypi_0    pypi
keras                     2.7.0                    pypi_0    pypi
keras-preprocessing       1.1.2                    pypi_0    pypi
kiwisolver                1.4.5                    pypi_0    pypi
ld_impl_linux-64          2.40                 h41732ed_0    conda-forge
libclang                  16.0.6                   pypi_0    pypi
libffi                    3.4.2                h7f98852_5    conda-forge
libgcc-ng                 13.2.0               h807b86a_5    conda-forge
libgomp                   13.2.0               h807b86a_5    conda-forge
libnsl                    2.0.1                hd590300_0    conda-forge
librosa                   0.9.2                    pypi_0    pypi
libsqlite                 3.45.1               h2797004_0    conda-forge
libuuid                   2.38.1               h0b41bf4_0    conda-forge
libxcrypt                 4.4.36               hd590300_1    conda-forge
libzlib                   1.2.13               hd590300_5    conda-forge
lightning-utilities       0.10.1                   pypi_0    pypi
llvmlite                  0.31.0                   pypi_0    pypi
markdown                  3.5.2                    pypi_0    pypi
markupsafe                2.1.5                    pypi_0    pypi
matplotlib                3.6.3                    pypi_0    pypi
more-itertools            10.2.0                   pypi_0    pypi
mpmath                    1.3.0                    pypi_0    pypi
multidict                 6.0.5                    pypi_0    pypi
ncurses                   6.4                  h59595ed_2    conda-forge
networkx                  3.1                      pypi_0    pypi
nnaudio                   0.3.3                    pypi_0    pypi
numba                     0.48.0                   pypi_0    pypi
numpy                     1.19.2                   pypi_0    pypi
nvidia-cublas-cu12        12.1.3.1                 pypi_0    pypi
nvidia-cuda-cupti-cu12    12.1.105                 pypi_0    pypi
nvidia-cuda-nvrtc-cu12    12.1.105                 pypi_0    pypi
nvidia-cuda-runtime-cu12  12.1.105                 pypi_0    pypi
nvidia-cudnn-cu12         8.9.2.26                 pypi_0    pypi
nvidia-cufft-cu12         11.0.2.54                pypi_0    pypi
nvidia-curand-cu12        10.3.2.106               pypi_0    pypi
nvidia-cusolver-cu12      11.4.5.107               pypi_0    pypi
nvidia-cusparse-cu12      12.1.0.106               pypi_0    pypi
nvidia-nccl-cu12          2.19.3                   pypi_0    pypi
nvidia-nvjitlink-cu12     12.3.101                 pypi_0    pypi
nvidia-nvtx-cu12          12.1.105                 pypi_0    pypi
oauthlib                  3.2.2                    pypi_0    pypi
openssl                   3.2.1                hd590300_0    conda-forge
opt-einsum                3.3.0                    pypi_0    pypi
packaging                 23.2                     pypi_0    pypi
pandas                    1.4.4                    pypi_0    pypi
pillow                    10.2.0                   pypi_0    pypi
pip                       24.0               pyhd8ed1ab_0    conda-forge
platformdirs              4.2.0                    pypi_0    pypi
pooch                     1.8.1                    pypi_0    pypi
protobuf                  3.19.6                   pypi_0    pypi
pyasn1                    0.5.1                    pypi_0    pypi
pyasn1-modules            0.3.0                    pypi_0    pypi
pycparser                 2.21                     pypi_0    pypi
pydot-ng                  2.0.0                    pypi_0    pypi
pynvml                    11.4.1                   pypi_0    pypi
pyparsing                 3.1.1                    pypi_0    pypi
python                    3.8.18          hd12c33a_1_cpython    conda-forge
python-dateutil           2.9.0.post0              pypi_0    pypi
python-magic              0.4.27                   pypi_0    pypi
python-slugify            8.0.4                    pypi_0    pypi
pytorch-lightning         1.9.5                    pypi_0    pypi
pytz                      2024.1                   pypi_0    pypi
pyyaml                    6.0.1                    pypi_0    pypi
readline                  8.2                  h8228510_1    conda-forge
regex                     2023.12.25               pypi_0    pypi
requests                  2.31.0                   pypi_0    pypi
requests-oauthlib         1.3.1                    pypi_0    pypi
resampy                   0.2.2                    pypi_0    pypi
rsa                       4.9                      pypi_0    pypi
ruamel-yaml               0.18.6                   pypi_0    pypi
ruamel-yaml-clib          0.2.8                    pypi_0    pypi
s3transfer                0.10.0                   pypi_0    pypi
safetensors               0.4.2                    pypi_0    pypi
schema                    0.7.5                    pypi_0    pypi
scikit-learn              1.3.2                    pypi_0    pypi
scipy                     1.9.3                    pypi_0    pypi
sed-eval                  0.2.1                    pypi_0    pypi
sentencepiece             0.2.0                    pypi_0    pypi
setuptools                69.1.1             pyhd8ed1ab_0    conda-forge
six                       1.16.0                   pypi_0    pypi
sortedcontainers          2.4.0                    pypi_0    pypi
soundfile                 0.12.1                   pypi_0    pypi
speechbrain               1.0.0                    pypi_0    pypi
spotty                    1.3.3                    pypi_0    pypi
sympy                     1.12                     pypi_0    pypi
tensorboard               2.14.0                   pypi_0    pypi
tensorboard-data-server   0.7.2                    pypi_0    pypi
tensorflow                2.7.4                    pypi_0    pypi
tensorflow-estimator      2.7.0                    pypi_0    pypi
tensorflow-io-gcs-filesystem 0.34.0                   pypi_0    pypi
termcolor                 2.4.0                    pypi_0    pypi
text-unidecode            1.3                      pypi_0    pypi
threadpoolctl             3.3.0                    pypi_0    pypi
tk                        8.6.13          noxft_h4845f30_101    conda-forge
tokenizers                0.15.2                   pypi_0    pypi
torch                     2.2.1                    pypi_0    pypi
torchaudio                2.2.1                    pypi_0    pypi
torchcrepe                0.0.22                   pypi_0    pypi
torchinfo                 1.8.0                    pypi_0    pypi
torchmetrics              0.11.4                   pypi_0    pypi
torchopenl3               1.0.1                    pypi_0    pypi
torchvision               0.17.1                   pypi_0    pypi
tqdm                      4.66.2                   pypi_0    pypi
transformers              4.38.2                   pypi_0    pypi
triton                    2.2.0                    pypi_0    pypi
typing-extensions         4.10.0                   pypi_0    pypi
uritemplate               4.1.1                    pypi_0    pypi
urllib3                   1.26.18                  pypi_0    pypi
validators                0.22.0                   pypi_0    pypi
werkzeug                  3.0.1                    pypi_0    pypi
wheel                     0.42.0             pyhd8ed1ab_0    conda-forge
wrapt                     1.16.0                   pypi_0    pypi
xz                        5.2.6                h166bdaf_0    conda-forge
yarl                      1.9.4                    pypi_0    pypi
zipp                      3.17.0                   pypi_0    pypi
```
