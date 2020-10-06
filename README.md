# Dockerfiles

自分用の色々な用途の docker images

他に docker 使用時の tips をまとめておく場所


## Installation

### docker-ce

公式ページ https://docs.docker.com/get-docker/ を見ると OS/Distribution ごとのインストール方法が書いてあるので、これに従うとインストールできる.

また、docker/docker-install https://github.com/docker/docker-install にあるscriptを使うと手軽にインストールできる.

### nvidia-docker

https://github.com/NVIDIA/nvidia-docker

上記の方法で docker-ce ( community edition ) をインストールした後に行う.

公式のインストールページの通りにインストールする. https://docs.nvidia.com/datacenter/cloud-native/container-toolkit/install-guide.html#docker

## Tips

### 知っていると嬉しいオプション

### nvidia-docker を用いて、コンテナでGPUを使う

ホストOSに nvidia driver を入れた上で以下のように --gpus all などの指定をつけてコンテナを立ち上げると、コンテナ内でGPUが使える

```
$ sudo docker run --rm --gpus all nvidia/cuda:11.0-base nvidia-smi
```

### ユーザーモードqemuを使って ARMエミュレーションを使って docker コンテナを立ち上げる.

http://inaz2.hatenablog.com/entry/2015/03/03/235759 を参照


