#!/bin/bash
# cpu占用top
# 用法: top.sh pid

sudo perf top -g -p $1