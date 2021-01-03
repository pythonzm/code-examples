#!/bin/sh
# 用户态时间 内核态时间 总运行时间 使用内存 执行命令
/usr/bin/time -f '%Uu %Ss %er %MkB %C' "$@"