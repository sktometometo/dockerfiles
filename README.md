# Dockerfiles

[![Docker Image Build Workflow](https://github.com/sktometometo/dockerfiles/actions/workflows/build.yaml/badge.svg)](https://github.com/sktometometo/dockerfiles/actions/workflows/build.yaml)

Some images are released at https://hub.docker.com/u/sktometometo

Docker images for various purpose. (Mainly for ROS + CUDA)

## Basic usage

Currently images below are available.

- TODO

### 全部入り起動方法

`<image name>`は変更すること

```bash
sudo docker run --net=host --privileged -v /dev:/dev -v /tmp/.X11-unix:/tmp/.X11-unix -e DISPLAY=$DISPLAY --gpus all -it sktometometo/<image name>
```

## Installation

### docker-ce

[公式ページ](https://docs.docker.com/get-docker/) を見ると OS/Distribution ごとのインストール方法が書いてあるので、これに従うとインストールできる.

また、docker/docker-install https://github.com/docker/docker-install にあるscriptを使うと手軽にインストールできる. ([この手順](https://docs.docker.com/engine/install/ubuntu/#install-using-the-convenience-script))

```bash
curl -fsSL https://get.docker.com -o get-docker.sh
sudo sh get-docker.sh
```

インストール後は以下のコマンドでコンテナが立ち上がるか確認

```
sudo docker run hello-world
```

インストール後は以下の作業をしておくと開発時に楽

#### sudo無しで動かせるようにする

参考: https://docs.docker.com/engine/install/linux-postinstall/#manage-docker-as-a-non-root-user

```
sudo groupadd docker
sudo usermod -aG docker $USER
```

サインアウト&サインインしたあとに,以下が動作するか確認する

```
docker run hello-world
```

#### PC起動時にdockerサービスが立ち上がるようにしておく

参考: https://docs.docker.com/engine/install/linux-postinstall/#configure-docker-to-start-on-boot

```
sudo systemctl enable docker.service
sudo systemctl enable containerd.service
```

### nvidia-docker

https://github.com/NVIDIA/nvidia-docker
上記の方法で docker-ce ( community edition ) をインストールした後に行う.
公式のインストールページの通りにインストールする. https://docs.nvidia.com/datacenter/cloud-native/container-toolkit/install-guide.html#docker
nvidia-drivers はインストールされているものとする.

```
distribution=$(. /etc/os-release;echo $ID$VERSION_ID) \
   && curl -s -L https://nvidia.github.io/nvidia-docker/gpgkey | sudo apt-key add - \
   && curl -s -L https://nvidia.github.io/nvidia-docker/$distribution/nvidia-docker.list | sudo tee /etc/apt/sources.list.d/nvidia-docker.list
sudo apt update
sudo apt install nvidia-docker2
docker service を restart
sudo systemctl restart docker
```

以下のコマンドで動作確認

```
sudo docker run --rm --gpus all nvidia/cuda:11.0-base nvidia-smi
```

## Tips

### よく使う使いかた


#### image を build する

```
$ sudo docker build -t <image名>:<タグ名> <dockerfileのある場所>
```

実行例

```
$ sudo docker build -t sktometometo:ros_melodic_cuda10.0 ./ros_melodic_cuda10.0
```

#### buildしたdockerイメージからコンテナを作成して実行

```
$ sudo docker run --rm -it <image name>:<tag name>
```

- `--rm`: コンテナ終了時にコンテナを自動削除
- `--it`: コンテナをインタラクティブモードで起動

#### buildしたdockerイメージをgpu付きでコンテナを作成して実行

ホストOSに nvidia driver を入れた上で以下のように --gpus all などの指定をつけてコンテナを立ち上げると、コンテナ内でGPUが使える

```
$ sudo docker run --rm -it --gpus all <image name>:<tag name>
```

#### ファイルをマウントしてコンテナを作成して実行

```
$ sudo docker run --rm -it -v <ホストのディレクトリ>:<コンテナ内のディレクトリ> <image name>:<tag name>
```

#### Hostマシンに接続したRealsenseをDocker Containerから使う

```
$ sudo docker run --rm -it --privileged -v /dev:/dev <image name>:<tag name> rs-enumerate-devices
```

#### ホストPCでコンテナ内部のGUIアプリケーションを表示する

```
$ sudo docker run --rm -it -v /tmp/.X11-unix:/tmp/.X11-unix -e DISPLAY=$DISPLAY <image name>:<tag name>
```

### ホストのネットワークインターフェースをコンテナと共有する.

```
$ sudo docker run --rm -it --net host <image name>:<tag name>
```

### ユーザーモードqemuを使って ARMエミュレーションを使って docker コンテナを立ち上げる.

http://inaz2.hatenablog.com/entry/2015/03/03/235759 を参照
