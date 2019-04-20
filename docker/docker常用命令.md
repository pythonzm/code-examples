# Docker常用命令

## 一、 镜像管理
### docker image ls

列出本机的所有 image 文件

### docker image rm [imageName]

删除 image 文件

### docker image pull [imageName]

抓取image文件，比如imageName是`library/hello-world`时候其中library是image文件所在的组，hello-world是image文件的名字。由于library是`docker`官方默认组，故可以省略，直接`docker image pull hello-world`

### docker image build -t [imageName:version] .

根据`Dockerfile`创建image文件,其中:version可以省略，默认是latest。

Dcokerfile示例:
```bash
FROM node:8.4 
// 该 image 文件继承官方的 node image，冒号表示标签，这里标签是8.4，即8.4版本的 node。

COPY . /app 
// 将当前目录下的所有文件（除了.dockerignore排除的路径），都拷贝进入 image 文件的/app目录。

WORKDIR /app 
// 指定接下来的工作路径为/app。 

RUN npm install --registry=https://registry.npm.taobao.org
// 在/app目录下，运行npm install命令安装依赖。
// 注意，安装后所有的依赖，都将打包进入 image 文件。

EXPOSE 3000 
// 将容器 3000 端口暴露出来， 允许外部连接这个端口。

CMD node demos/01.js 
// 容器启动后自动执行node demos/01.js。
// RUN命令在 image 文件的构建阶段执行，执行结果都会打包进入 image 文件；
// CMD命令则是在容器启动后执行。一个Dockerfile可以包含多个RUN命令，但只能有一个CMD命令
```

### docker inspect [imageName/containerID]

容器/镜像的元数据

### docker commit
```
docker commit --author "yubing" --message "use disqus" blog yubing/blog:0.2.2
// 提交对容器blog的修改至yubing/blog:0.2.2镜像中
```

### docker diff/hisotry [imageName]
查看镜像变化或者提交历史


## 二、 容器管理

### docker create

创建容器

### docker container run [imageName] 

从image文件生成一个正在运行的容器实例。该命令具有自动抓取image文件的功能，若本地没有发现image文件就会自动从仓库抓取。每运行一次，就会新建一个容器。

```bash
docker container run --rm -p 8000:3000 --name koa -it koa-demo:0.0.1 /bin/bash
```

1. -p参数：容器的 3000 端口映射到本机的 8000 端口。
2. -it参数：容器的 Shell 映射到当前的 Shell，然后你在本机窗口输入的命令，就会传入容器。-i让容器中STDIN开启，-t是告诉Docker为要创建的容器分配一个伪tty终端
3. --rm 在容器终止运行后自动删除容器文件
4. koa-demo:0.0.1：image 文件的名字（如果有标签，还需要提供标签，默认是 latest 标签）。
5. --name 为容器命名，容器名字默认是UUID格式的。
6. /bin/bash：容器启动以后，内部第一个执行的命令。这里是启动 Bash，保证用户可以使用 Shell。


### docker container start [containerID] 

用来启动已经生成、已经停止运行的容器文件


### docker container kill [containerID] 

对于不会自动终止的容器,使用此命令杀死，向容器里面的主进程发出`SIGKILL`信号

### docker container stop [containerID] 

终止容器运行,相当于向容器里面的主进程发出`SIGTERM`信号,应用程序接收到此信号时候可以进行清理工作，然后过一段时间再发出`SIGKILL`信号。

### docker attach [containerID]

用来附着到容器上

### docker container ls 

列出本机正在运行的容器

### docker container ls --all 

列出本机所有容器，包括终止运行的容器

### docker ps -a

显示所有的容器，包括未运行的,`-q`返回容器的ID

### docker container rm [containerID] 

删除容器，终止运行的容器文件，依然会占据硬盘空间

### docker top [containerID]

查看容器进程信息

### docker container logs [containerID] 

查看docker容器的输出

### docker continer exec -it [containerID] /bin/bash 

用于进入一个正在运行的 docker 容器。如果docker run命令运行容器的时候，没有使用-it参数，就要用这个命令进入容器

### docker container cp [containID]:[/path/to/file] 

用于从正在运行的 Docker 容器里面，将文件拷贝到本机

### docker port [containerName/containerID] port

查看容器公开的端口port对应的宿主端口

## 三、Docker守护进程管理

配置守护进程

```
sudo /usr/bin/docker -d -H tcp://0.0.0.0:2375
```
-H用来指定服务器地址，除了端口形式，也可以是Unix套接字路径。可用通过配置DOCKER_HOST环境变量来设服务器地址