#!/bin/bash

# 用法: mem.sh pid
# 
# Note:
#   This script can collect the malloc profile, if you link other memory allocator
#   like jemalloc, you may use `perf probe` to add the probe at first.
perfFile=/tmp/perf-mem-$(date +%s).data
sudo perf record -e malloc -F 99 -p $1 -g -o $perfFile -- sleep 10
sudo perf script -i $perfFile | /opt/FlameGraph/stackcollapse-perf.pl  | /opt/FlameGraph/flamegraph.pl  --colors=mem > mem.svg