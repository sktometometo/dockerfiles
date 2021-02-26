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

### よく使う使いかた

* image を build する

```
$ sudo docker build -t <image名>:<タグ名> .
```

* buildしたdockerイメージを走らせる

```
$ sudo docker run --rm -it <container Name> /bin/bash
```

** `--rm`: コンテナ終了時にコンテナを自動削除

** `--it`: コンテナをインタラクティブモードで起動

* buildしたdockerイメージをgpu付きで走らせる

```
$ sudo docker run --rm -it --gpus all <container Name> /bin/bash
```

* ファイルをマウントしてdockerを走らせる

```
$ sudo docker run --rm -v <ホストのディレクトリ>:<コンテナ内のディレクトリ>  -it <container Name> /bin/bash
```

### 知っていると嬉しいオプション

### ホストのネットワークインターフェースをコンテナと共有する.

```
$ sudo docker run --rm -it --net host <container name>
```

### nvidia-docker を用いて、コンテナでGPUを使う

ホストOSに nvidia driver を入れた上で以下のように --gpus all などの指定をつけてコンテナを立ち上げると、コンテナ内でGPUが使える

```
$ sudo docker run --rm --gpus all nvidia/cuda:11.0-base nvidia-smi
```

### ユーザーモードqemuを使って ARMエミュレーションを使って docker コンテナを立ち上げる.

http://inaz2.hatenablog.com/entry/2015/03/03/235759 を参照


