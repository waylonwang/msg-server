# CloudValley QQBot : Message Server
【云谷QQ机器人】之「消息服务器」

[![License](https://img.shields.io/badge/License-MIT-orange.svg)](https://github.com/waylonwang/msg-server/master/LICENSE)
[![Docker Repository](https://img.shields.io/badge/docker-cloudvalley%2Fmsg--server-green.svg)](https://hub.docker.com/r/cloudvalley/msg-server/)

## CloudValley QQBot项目
### 业务架构
【CloudValley QQBot】项目计划实现一个自动处理消息指令的QQ机器人来处理一些私有项目上的需求，本服务器是【CloudValley QQBot】项目的关键组成部分，基于[CoolQ/docker-wine-coolq](https://github.com/CoolQ/docker-wine-coolq)(CoolQ)镜像和[richardchien/coolq-http-api](https://github.com/richardchien/coolq-http-api)(HTTP API)插件整合的酷Q服务器，用于VPS挂机实现QQ收发消息服务。

![CloudValley QQBot Framework](docs/CloudValley-QQBot.png)

【CloudValley QQBot】项目的另一关键组成部分是基于[CCZU-DEV/xiaokai-bot](https://github.com/CCZU-DEV/xiaokai-bot)改造的[waylonwang/cmd-server](https://github.com/waylonwang/cmd-server)(「Command Server」)指令处理服务器，用于本服务器消息的调度与逻辑处理。

### 技术选型
【CloudValley QQBot】项目尝试了GitHub上基于SmartQQ(Web QQ) API的众多开源项目，包括采用nodejs、perl、python等语言实现的QQBot，这些QQBot除了少量特性（如@用户）无法实现外，基本的IM需求和群管需求还是可以满足的，其中部分QQBot甚至采用了插件机制得以将业务处理的逻辑与框架主体分离实现松耦合，但是由于SmartQQ并非腾讯发展的重点，且貌似已不再维护，因此采用Web QQ协议的项目都先天存在风险，尤其是时不时一些API被关停或调整影响了机器人的稳定性，因此依赖于SmartQQ存在着极大的风险。

【CloudValley QQBot】项目在最初的选型上曾经考虑过采用以酷Q为代表的安卓QQ协议来实现，但是酷Q官方以易语言来实现插件，这实在是难以接受的一种状况，因此曾经放弃了酷Q这条路线。

在经历了连续数次个别Web QQ协议(群管)被关停的风波后，【CloudValley QQBot】项目重新把目光转回到了酷Q的方案上，最终找到[richardchien/coolq-http-api](https://github.com/richardchien/coolq-http-api)插件提供了很好的扩展性且符合当代互联网开发技术的潮流，从而不再被易语言问题困扰，得以将消息的收发与指令的处理进行分离。同时[CoolQ/docker-wine-coolq](https://github.com/CoolQ/docker-wine-coolq)镜像提供了在VPS的linux系统上长期挂机的可能性，使得【CloudValley QQBot】项目能在使用docker这种热门容器技术的同时又获得了酷Q稳定可靠的完备能力。并且之后找到了[CCZU-DEV/xiaokai-bot](https://github.com/CCZU-DEV/xiaokai-bot)机器人近乎完美的实现了理想中的消息过滤与指令处理框架，【CloudValley QQBot】项目就此终于确定了目前的架构。

## Message Server
### 内容
「Message Server」镜像继承了CoolQ/docker-wine-coolq镜像和richardchien/coolq-http-api插件，当前集成的coolq-http-api版本号是v1.1.2，整合后的「Message Server」镜像中，CoolQ默认启用了"HTTP API"插件和"状态监控"插件。

### 预备
首先你需要准备一个可以长期运行docker的操作系统环境，建议安装好docker-compose以便运行YAML文件，另外，如果你不太适应docker的命令交互方式，可以安装docker-ui使用图形化界面进行操作。

由于cloudvalley/msg-server镜像文件有1.6GB的容量，在国内拉取会非常慢，建议先配置国内的mirror服务来加速下载：
```
curl -sSL https://get.daocloud.io/daotools/set_mirror.sh | sh -s http://51418756.m.daocloud.io
```
有关daocloud mirror服务的详细说明请参见[配置 Docker 加速器](https://www.daocloud.io/mirror#accelerator-doc)
### 拉取镜像
「Message Server」的docker镜像可通过以下命令获得：
```
docker pull cloudvalley/msg-server
```
### 运行前配置
"HTTP API"插件的post_url配置项指向了`http://127.0.0.1:8888/coolq_http_api/REPLACE_QQ_ACCOUNT/`，如果启动容器时配置了COOLQ_ACCOUNT环境变量，post_url配置项中的REPLACE_QQ_ACCOUNT会被替换成COOLQ_ACCOUNT的变量值，【CloudValley QQBot】项目默认采用[waylonwang/cmd-server](https://github.com/waylonwang/cmd-server)作为指令处理服务器，你可以随时修改该配置为自己的指令处理服务器。
CoolQ所使用的环境变量可在docker-compose.yml文件中直接修改，信息的配置内容请参见[CoolQ/docker-wine-coolq](https://github.com/CoolQ/docker-wine-coolq)原作者的描述。

### 运行容器
通过docker-compose命令来直接执行docker-compose.yml文件，如本地尚未拉取镜像则会自动拉取：
```
docker-compose up -d
```

运行以上docker-compose命令同时会创建名为msg-server的容器，除了docker-compose命令外，你也可以通过docker run命令创建容器来运行本服务器：
```
docker run --name msg-server -p 9000:9000 -e "VNC_PASSWD=123456" -e "COOLQ_ACCOUNT=替换为QQ号" -d cloudvalley/msg-server
```
### 运行后配置
CoolQ登录必须通过VNC来操作，配置好"HTTP API"插件后，访问 `http://你的IP:9000` 输入密码123456即可以打开一个 VNC 页面登录QQ，要注意的是，由于novnc本身的原因，VNC页面如果点击无响应的话刷新页面重新连接VNC即正常可操作了。

### 局限性
【CloudValley QQBot】项目目前用于私有项目，从安全角度出发直接通过docker的“container”网络模式将「Command Server」与「Message Server」的IP合并到一起进行本地调用，因此「Message Server」并未开放"HTTP API"插件的API端口到外部，如你需要通过外部直接调用"HTTP API"插件的API，请自行修改docker-compose.yml文件或docker run命令映射端口实现外部的访问。
