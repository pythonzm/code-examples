<?php

class Obj
{
    private $name = 'an object';

    /**
     * @see http://php.net/manual/zh/language.oop5.visibility.php
     * 同一个类的对象即使不是同一个实例也可以互相访问对方的私有与受保护成员。这是由于在这些对象的内部具体实现的细节都是已知的。
     */
    public function exportBrotherObj(Obj $obj)
    {
        echo $obj->name . "\n"; // 在同一类的示例里面，可以访问另外的对象的私有属性或方法
        $obj->name = "another object";
        echo $obj->name . "\n";
    }
}

$instance = new Obj;
//echo $instance->name; // error Cannot access private property Obj::$name
$anotherInstance = new Obj;
$instance->exportBrotherObj($anotherInstance);
