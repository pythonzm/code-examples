<?php

class Animal
{
    const TYPE = 'animal';

    public function sayType()
    {
        echo self::TYPE . "\n";
    }
}

class Dog extends Animal
{
    public function sayType()
    {
        parent::sayType();
        echo self::TYPE . "\n"; // 对于父类的常量，可以用self或parent加上范围解析操作符来访问,输出都是"animal"
        echo parent::TYPE . "\n";
    }
}

$dog = new Dog;

$dog->sayType();

echo Dog::TYPE . "\n";
echo Animal::TYPE . "\n";
