## 火焰图使用

1. 首先安装依赖命令

`install_perf_in_ubuntu.sh`脚本用来安装perf命令和Brendan D. Gregg的Flame Graph工具包

2. cpu采样并生成火焰图

这里面是利用perf命令生成火焰图。分为三步走：

- 第一步是**采样程序运行的堆栈**，这一步利用perf/systemtap等trace工具。

    sudo perf record -F 99 -p 8900 -g -o $perfFile -- sleep 60 
    - perf record 用于采集事件，可以使用-e指定采集事件
    - -F 99表示每秒采样99次
    - -p 8900指定采样的进程
    - -g表示记录调用栈信息
    - -o perfile表示采样数据输出到perfile文件中
    - -- sleep 60表示采样60s


- 第二步是**折叠堆栈**，这是因为第一步采样的是系统和程序运行每一时刻的堆栈信息, 需要对他们进行分析组合, 将重复的堆栈累计在一起, 从而体现出负载和关键路径。这一步利用的是Flame Graph工具包中的 stackcollapse 程序。

    - perf script -i perf.data &> perf.unfold

        对第一步中采集的perf.data数据进行解析
    - ./stackcollapse-perf.pl perf.unfold &> perf.folded

        进行折叠堆栈处理

- 第三步是**生成火焰图🔥**，利用Flame Graph工具包中flamegraph.pl分析stackcollapse 输出的堆栈信息生成火焰图

    - ./flamegraph.pl perf.folded > perf.svg

        生成火焰图

上面三步走流程可以通过管道简化成一条命令，具体见cpu.sh


3. 分析火焰图

**火焰图含义：**

火焰图是基于 stack 信息生成的 SVG 图片, 用来展示 CPU 的调用栈。

y 轴表示调用栈, 每一层都是一个函数. 调用栈越深, 火焰就越高, 顶部就是正在执行的函数, 下方都是它的父函数.

x 轴表示抽样数, 如果一个函数在 x 轴占据的宽度越宽, 就表示它被抽到的次数多, 即执行的时间长. 注意, x 轴不代表时间, 而是所有的调用栈合并后, 按字母顺序排列的.

火焰图就是看顶层的哪个函数占据的宽度最大. 只要有 "平顶"(plateaus), 就表示该函数可能存在性能问题。

颜色没有特殊含义, 因为火焰图表示的是 CPU 的繁忙程度, 所以一般选择暖色调.

**火焰图使用：**

- 鼠标悬浮

火焰的每一层都会标注函数名, 鼠标悬浮时会显示完整的函数名、抽样抽中的次数、占据总抽样次数的百分比。比如：Function：main(3866 samples, 98.67%)


- 点击放大

在某一层点击，火焰图会水平放大，该层会占据所有宽度，显示详细信息。

左上角会同时显示 "Reset Zoom", 点击该链接, 图片就会恢复原样.


**局限性：**

- 调用栈不完整

当调用栈过深时，某些系统只返回前面的一部分（比如前10层）。

- 函数名缺失

有些函数没有名字，编译器只用内存地址来表示（比如匿名函数）。

## 红蓝分叉火焰图

上面介绍的火焰图可能很好定位到CPU负载问题，但对于性能回退问题，比如发布新版本之后软件的性能相比旧版本有所下降，对于这类的问题，我们可以使用红/蓝差分火焰图(red/blue differential flame graphs)。

**工作原理：**

- 抓取修改前的堆栈 profile1 文件

- 抓取修改后的堆栈 profile2 文件

- 使用 profile2 来生成火焰图. (这样栈帧的宽度就是以profile2 文件为基准的)

- 使用 "2-1" 的差异来对火焰图重新上色. 上色的原则是, 如果栈帧在 profile2 中出现出现的次数更多, 则标为红色, 否则标为蓝色. 色彩是根据修改前后的差异来填充的.

**使用：**

```
# 旧代码运行后数据
perf record -F 99 -a -g -- sleep 30 # 采集数据
perf script > out.stacks1 #	解析数据生成堆栈信息
./stackcollapse-perf.pl ../out.stacks1 > out.folded1 #	折叠堆栈


# 新代码运行后数据
perf record -F 99 -a -g -- sleep 30 # 采集数据
perf script > out.stacks2 #	解析数据生成堆栈信息
./stackcollapse-perf.pl ../out.stacks2 > out.folded2 #	折叠堆栈

# 生成红蓝差分火焰图

# 宽度是以修改后profile文件为基准，颜色表明已经发生的情况
./difffolded.pl out.folded1 out.folded2 | ./flamegraph.pl > diff2.svg

# 宽度是以修改前profile文件为基准，颜色表明将要发生的情况
./difffolded.pl out.folded2 out.folded1 | ./flamegraph.pl --negate > diff1.svg
```

## 资料

- [Linux下用火焰图进行性能分析](https://github.com/gatieme/LDD-LinuxDeviceDrivers/tree/master/study/debug/tools/perf/flame_graph#linux%E4%B8%8B%E7%94%A8%E7%81%AB%E7%84%B0%E5%9B%BE%E8%BF%9B%E8%A1%8C%E6%80%A7%E8%83%BD%E5%88%86%E6%9E%90)
- [Blazing Performance with Flame Graphs](http://www.slideshare.net/brendangregg/blazing-performance-with-flame-graphs)
- [Choosing a Linux Tracer](https://www.brendangregg.com/blog/2015-07-08/choosing-a-linux-tracer.html)
- [Linux Profiling at Netflix](http://www.slideshare.net/brendangregg/scale2015-linux-perfprofiling)
- [Flame Graph](https://github.com/brendangregg/FlameGraph)
- [Broken Linux Performance Tools 2016](https://www.slideshare.net/brendangregg/broken-linux-performance-tools-2016?next_slideshow=1)