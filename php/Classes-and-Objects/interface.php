<?php

interface IView
{
    public function display($template);
    public function assign($key, $val);
}

class PHPView implements IView
{
    protected $viewData = [];

    public function display($template)
    {
        extract($this->viewData);
        include $template;
    }

    public function assign($key, $val)
    {
        $this->viewData[$key] = $val;
    }
}

$viewer = new PHPView();
$viewer->assign('titie', 'hello, world');
$viewer->display('helloworld.php');
