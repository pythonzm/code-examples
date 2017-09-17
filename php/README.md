This is a collection of examples of php

## Index

* [Predefined-Interfaces-and-Classes](https://github.com/cyub/code-examples/tree/master/php/Predefined-Interfaces-and-Classes) 预定接口与类
    * [Iterator/IteratorAggregate 迭代器/聚合迭代器接口](https://github.com/cyub/code-examples/blob/master/php/Predefined-Interfaces-and-Classes/myIterator.php)
    * [ArrayAccess 数组访问访问接口](https://github.com/cyub/code-examples/blob/master/php/Predefined-Interfaces-and-Classes/arrayAndObjectAccess.php)
    * [Serialize 序列化接口](https://github.com/cyub/code-examples/blob/master/php/Predefined-Interfaces-and-Classes/objSerialize.php)
    * Counter 计数器接口
    * Closure 闭包类
    * Generator 生成器类

* [SPL](https://github.com/cyub/code-examples/tree/master/php/SPL)
    * [PriorityQueue 优先级队列](https://github.com/cyub/code-examples/blob/master/php/SPL/splPriorityQueue.php)

* [Classes-and-Objects](https://github.com/cyub/code-examples/tree/master/php/Classes-and-Objects)
    * [抽象类](https://github.com/cyub/code-examples/tree/master/php/Classes-and-Objects/class_abstraction.php)
    
    子类定义了一个可选参数，而父类抽象方法的声明里没有，是可以的

    * [访问控制](https://github.com/cyub/code-examples/tree/master/php/Classes-and-Objects/object_access_control.php)
     
     在同一类的不同实例的方法里面，另一个对象所有属性和方法都是可见的

    * [对象生命周期](https://github.com/cyub/code-examples/tree/master/php/Classes-and-Objects/object_lifecycle.php)
    
    TTL: \__construct < exit < regsiter_shutdown < \__destruct

    * [范围解析操作符](https://github.com/cyub/code-examples/tree/master/php/Classes-and-Objects/scope_resolution_operator.php)
    * [引用](https://github.com/cyub/code-examples/tree/master/php/Classes-and-Objects/object_reference.php)
    * [接口](https://github.com/cyub/code-examples/tree/master/php/Classes-and-Objects/interface.php)
        * 实现多个接口时，接口中的方法不能有重名
        * 接口通过使用extends操作符实现继承
        * 类要实现接口，必须使用和接口中所定义的方法完全一致的方式。否则会导致致命错误
        * 接口中也可以定义常量。接口常量和类常量的使用完全相同，但是不能被子类或子接口所覆盖
    
    * [trait](https://github.com/cyub/code-examples/tree/master/php/Classes-and-Objects/trait.php)
    
    优先级顺序是：当前类的成员方法 > trait方法 > 继承的方法


