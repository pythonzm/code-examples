# Shell编程基础

## 1. 变量与参数

**变量赋值**

使用variable=value的命令格式设置变量，其中variable是变量名称，value是打算赋给该变量的值。使用 `$variable`获取变量值

```
PI=3.1415
TITLE="it is title"
echo $PI
export PI // 设置环境变量
unset PI // 删除环境变量
CWD=`pwd`
DIRNAME=`basename $CURRPW`
PORT=${3:-9000} // 默认值9000
message << HEREDOC // heredoc
it is message
HEREDOC
```


**命令行参数：**

```
$0, $1, $2, ... // $0命令本身 $1第一个参数
$# // 命令参数个数
$* // 所有参数(或者$@)
```

**特殊的变量**

```
$$ // 当前进程id
$? // 最后命令退出状态码
```

**变量运算**
```
no1=4
no2=5
let result=no1+no2
result=$[ no1 + no2 ]
result=$[ $no1 + $no2 ]
result=$((no1 + no2))
result=`expr $no1 + $no2`
result=$(expr $no1 + no2)

echo "4 * 0.56" | bc

no=54;// 必须以分号结束
result=`echo "$no * 1.5" | bc`
echo $result

设置小数精度
echo "scale=2;3/8" | bc //参数scale=2将小数位个数设置为2

进制转换：
no=100
echo "obase=2;$no" | bc
no=1100100
echo "obase=10;ibase=2;$no" | bc

计算平方以及平方根
echo "sqrt(100)" | bc
echo "10^10" | bc
```

**数组**
```
array_var=(1 2 3)
array_var[2]='2a'
index=2
echo ${array_var[$index]}//输出2a
echo ${array_var[*]}// 输出所有内容，或者${array_var[@]}
echo ${#array_var[*]}// 输出数组长度，或者${#array_var}
echo ${!arr[*]} //输出素组索引
fruits_value=([apple]='100dollars' [orange]='150 dollas') //bash4.0支持索引数组

mytest=(one two three)
echo $mytest // 输出one
echo ${mytest[2]}// 输出three
echo ${mytest[*]} // 输出one two three
mytest[2]=four
echo ${mytest[*]} // 输出onw two four
unset mytest // 删除mytest
```

## 2. 结构控制
```
for file in `ls`
do
    echo $file
done

count=0
while [ $count -lt 5 ]; do
    echo $count
    sleep 1
    count=$(($count + 1))
done

if [ -f "${CURRPWD}/public/${INDEX_FILE}" ]; then
    ROOT=$CURRPWD/public
elif [ -f "${CURRPWD}/${INDEX_FILE}" ]; then
    ROOT=$CURRPWD
else
    echo  "index file not exists!"
    return 1
fi

myfunction() {
    find . -type f -name "*.$1" -print       # $1 为方法的第一个参数
}
myfunction "txt"
```

## 3. 调试脚本
```
使用x选项调试脚本
bash -x script.sh

或者设置shebang
!#/bin/bash -xv
```



