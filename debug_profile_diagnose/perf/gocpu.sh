#!/bin/bash
# 生成Go应用的火焰图
# 用法: gocpu.sh pid
# -F 99: 每秒99次采样  -p $1: 指定进程id -g: 记录调用栈信息 -- sleep 60: 持续记录60秒

perfFile=/tmp/perf-cpu-$(date +%s).data
sudo perf record -F 99 -p $1 -g -o $perfFile -- sleep 60 
sudo perf script -i $perfFile | /opt/FlameGraph/stackcollapse-go.pl | /opt/FlameGraph/flamegraph.pl > cpu.svg