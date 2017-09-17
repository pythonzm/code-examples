<?php

class Base
{
    public function sayHello()
    {
        echo 'Hello ';
    }
}

trait SayWorld
{
    public function sayHello()
    {
        parent::sayHello();
        echo 'World!';
    }
}

class MyHelloWorld extends Base
{
    use SayWorld;

    // 优先级顺序是：当前类的成员方法>trait方法>继承的方法
    public function sayHello()
    {
        echo 'new hello world';
    }
}

$o = new MyHelloWorld();
$o->sayHello(); // 输出new hello world
