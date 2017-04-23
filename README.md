# CloudValley QQBot : CoolQ HTTP Server
【云谷QQ机器人】之「酷Q HTTP服务器」

[![License](https://img.shields.io/badge/License-MIT-orange.svg)](https://github.com/waylonwang/coolq-http-server/master/LICENSE)
[![Docker Repository](https://img.shields.io/badge/docker-cloudvalley%2Fcoolq--http-green.svg)](https://hub.docker.com/r/cloudvalley/coolq-http/)
[![Docker Pulls](https://img.shields.io/badge/docker%20pull-11-blue.svg)](https://hub.docker.com/r/cloudvalley/coolq-http/)

## CloudValley QQBot项目
### 项目组成
CloudValley QQBot项目计划实现一个自动处理消息指令的QQ机器人来处理一些私有项目上的需求，本服务器是CloudValley QQBot项目的关键组成部分，基于[CoolQ/docker-wine-coolq](https://github.com/CoolQ/docker-wine-coolq)(CoolQ)镜像和[richardchien/coolq-http-api](https://github.com/richardchien/coolq-http-api)(HTTP API)插件整合的酷Q HTTP服务器，用于VPS挂机实现QQ收发消息服务。

CloudValley QQBot项目的另一关键组成部分是基于[CCZU-DEV/xiaokai-bot](https://github.com/CCZU-DEV/xiaokai-bot)改造的[waylonwang/xiaokai-bot](https://github.com/waylonwang/xiaokai-bot)指令处理机器人，用于本服务器收发消息的自动处理。

### 项目选型
CloudValley QQBot项目尝试了GitHub上基于SmartQQ(Web QQ) API的众多开源项目，包括采用nodejs、perl、python等语言实现的QQBot，这些QQBot除了少量特性（如@用户）无法实现外，基本的IM需求和群管需求还是可以满足的，但是由于SmartQQ并非腾讯发展的重点，且貌似已不再维护，因此采用Web QQ协议的项目都先天存在风险，尤其是时不时一些API被关停或调整影响了机器人的稳定性，因此依赖于SmartQQ存在着极大的风险。

CloudValley QQBot项目在最初的选型上曾经考虑过采用以酷Q为代表的安卓QQ协议来实现，但是酷Q官方以易语言来实现插件，这实在是难以接受的一种状况，因此曾经放弃了酷Q这条路线。

在经历了连续两次个别Web QQ协议(群管)被关停的风波后，CloudValley QQBot项目重新把目光转回到了酷Q的方案上，最终找到[richardchien/coolq-http-api](https://github.com/richardchien/coolq-http-api)插件提供了强大的扩展性且符合当代互联网开发技术的潮流，从而不再被易语言问题困扰，同时[CoolQ/docker-wine-coolq](https://github.com/CoolQ/docker-wine-coolq)镜像提供了在VPS的linux系统上长期挂机的可能性，使得CloudValley QQBot项目能在使用docker这种热门容器技术的同时又获得了酷Q稳定可靠的完备能力。

## CoolQ HTTP Server
### 内容
CoolQ HTTP Server镜像继承了CoolQ/docker-wine-coolq镜像和richardchien/coolq-http-api插件，当前集成的coolq-http-api版本号是v1.1.2，整合后的CoolQ HTTP Server镜像中，CoolQ默认启用了"HTTP API"插件和"状态监控"插件。

### 预备
首先你需要准备一个可以长期运行docker的操作系统环境，建议安装好docker-compose以便运行yml脚本，另外，如果你不太适应docker的命令交互方式，可以安装docker-ui使用图形化界面进行操作。
### 拉取镜像
CoolQ HTTP Server的docker镜像可通过以下命令获得：
```
docker pull cloudvalley/coolq-http
```
### 运行容器
即便不手工拉取镜像，也可以通过docker-compose命令来直接执行docker-compose.yml文件，如本地没有这个镜像就会自动重新下载：
```
docker-compose up -d
```

运行以上docker-compose命令时回同时创建名为coolq-http的容器，除了docker-compose命令外，你也可以通过docker run命令创建容器来运行本服务器：
```
docker run --name coolq-http -p 9000:9000 -d cloudvalley/coolq-http

```
### 配置
CloudValley QQBot项目默认采用[waylonwang/xiaokai-bot](https://github.com/waylonwang/xiaokai-bot)作为指令处理机器人，
CloudValley QQBot项目目前用于私有项目，为了方便部署，镜像中直接写死了测试用的QQ号，因此"HTTP API"插件post_url指向了`http://127.0.0.1:8888/coolq_http_api/3010897940/`，你可以随时修改该配置为自己的指令处理机器人。
coolq-http容器运行后，通过docker exec命令进入容器内用vim修改"HTTP API"插件的上报地址：
```
docker exec -ti coolq-http /bin/bash

```

用vim编辑配置文件：
```
vim /home/user/coolq/app/io.github.richardchien.coolqhttpapi/config.cfg
```
详细的配置内容请参见[richardchien/coolq-http-api](https://github.com/richardchien/coolq-http-api)和[CCZU-DEV/xiaokai-bot](https://github.com/CCZU-DEV/xiaokai-bot)原作者的描述。

CoolQ所使用的环境变量可在docker-compose.yml文件中直接修改，信息的配置内容请参见[CoolQ/docker-wine-coolq](https://github.com/CoolQ/docker-wine-coolq)原作者的描述。

CoolQ登录必须通过VNC来操作，配置好"HTTP API"插件后，访问 `http://你的IP:9000` 可以打开一个 VNC 页面登录QQ，要注意的是由于novnc本身的原因，VNC页面如果点击无响应的话刷新页面重新连接VNC即正常可操作了。
### 局限性
CoolQ HTTP Server项目目前用于私有项目，从安全角度出发直接通过docker的“其他容器”网络模式将xiaokai-bot与CoolQ HTTP Server的IP合并到一起进行本地调用，因此CoolQ HTTP Server并未开放5700端口到公网，如你需要通过公网直接调用"HTTP API"插件的API，请自行修改docker-compose.yml文件或docker run命令映射端口实现公网的访问。
