<?php

abstract class AbstractClass
{
    abstract protected function prefixName($name);
    abstract protected function suffixName($name);
}

class ConcreteClass extends AbstractClass
{
    // 某个抽象方法被声明为受保护的，那么子类中实现的方法就应该声明为受保护的或者公有的，而不能定义为私有的。此外方法的调用方式必须匹配，即类型和所需参数(required arguments)必须一致。子类定义了一个可选参数，而父类抽象方法的声明里没有，是可以的。
    public function prefixName($name, $separator = '.')
    {
        if ($name == 'Pacman') {
            $prefix = "Mr";
        } else {
            $prefix = "Mrs";
        }
        return "{$prefix}{$separator} {$name}";
    }

    public function suffixName($name)
    {
        return "{$name} .suffix";
    }
}

$class = new ConcreteClass;

echo $class->prefixName("Pacman"), "\n";
echo $class->suffixName("Pacwoman"), "\n";
