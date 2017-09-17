<?php

class Obj
{
    public $name = 'an object';

    // use heredoc init variable at php>5.3.0
    public $newName =<<<EOD
it is another name
EOD;
}

$instance = new Obj;

$assign = $instance;
$reference = &$instance;

$instance->name = 'another object';
$instance = null; // $instance and $reference become null

var_dump($instance);
var_dump($assign);
var_dump($reference);
