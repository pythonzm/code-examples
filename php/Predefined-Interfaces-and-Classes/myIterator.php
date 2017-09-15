<?php

class MyIterator implements Iterator
{
    private $position = 0;
    private $array = [
        'first',
        'second',
        'last',
    ];

    public function __construct()
    {
        $this->position = 0;
    }

    public function rewind()
    {
        //var_dump(__METHOD__);
        $this->position = 0;
    }

    public function current()
    {
        //var_dump(__METHOD__);
        return $this->array[$this->position];
    }

    public function key()
    {
        //var_dump(__METHOD__);
        return $this->position;
    }

    public function next()
    {
        //var_dump(__METHOD__);
        ++$this->position;
    }

    public function valid()
    {
        //var_dump(__METHOD__);
        return isset($this->array[$this->position]);
    }
}

$it = new MyIterator;
// example 1
foreach ($it as $key => $value) {
    var_dump($key, $value);
    echo "\n";
}

// example2

$it->rewind();
while ($it->valid()) {
    var_dump($it->key(), $it->current());
    $it->next();
}


// example3

for ($it->rewind(); $it->valid(); $it->next()) {
    var_dump($it->key(), $it->current());
}
