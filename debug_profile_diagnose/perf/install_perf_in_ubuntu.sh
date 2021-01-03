#!/bin/sh
sudo apt-get -y install linux-tools-$(uname -r) # 安装perf
wget https://github.com/brendangregg/FlameGraph/archive/master.zip # 火焰图生成工具
unzip master.zip
sudo mv FlameGraph-master/ /opt/FlameGraph