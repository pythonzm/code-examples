<?php

class Obj
{
    public function __construct()
    {
        echo __FUNCTION__ . "\n";
    }

    /**
     * @see http://php.net/manual/zh/language.oop5.decon.php
     * 构函数即使在使用 exit() 终止脚本运行时也会被调用。在析构函数中调用 exit() 将会中止其余关闭操作的运行。
     */
    public function __destruct()
    {
        echo __FUNCTION__ . "\n";
    }
}

$instance = new Obj();

register_shutdown_function(function () {
    echo "register_shutdown_function\n";
});
exit("exit\n");
/**
 * 输出内容如下：
 *
__construct
exit
register_shutdown_function
__destruct
 */
