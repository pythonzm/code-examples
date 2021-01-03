### 1. php-fpm允许连接的ip设置导致的502问题

浏览器打开页面提示502，查看nginx日志提示
>[error] 1571#0: *1 recv() failed (104: Connection reset by peer) while reading response header from upstream, client: 10.211.55.2, server: localhost, request: "GET /index.php HTTP/1.1", upstream: "fastcgi://127.0.0.1:9000", host: "10.211.55.3"。

应该是php-fpm有问题。在php-fpm配置文件/usr/local/php7/etc/php-fpm.d里面开启catch_workers_output,查看php-fpm的错误日志,看见
>WARNING: [pool www] child 3462 said into stderr: "ERROR: Connection disallowed: IP address '127.0.0.1' has been dropped."

这是由于php-fpm配置listen.allowed_clients错误导致本地不能连接php-fpm。修改此项增加相应ip即可

### 2. php页面提示"File not found."问题

查看nginx日志提示
>[error] 9330#0: *48 FastCGI sent in stderr: "Primary script unknown" while reading response header from upstream, client: 10.211.55.2, server: localhost, request: "GET /a.php HTTP/1.1", upstream: "fastcgi://127.0.0.1:9000", host: "10.211.55.3"

问题一般都是是由于fastcgi参数SCRIPT_FILENAME配置错误导致，正确配置如下：
```
# nginx.conf
location ~ \.php$ {
    fastcgi_pass   127.0.0.1:9000;
    fastcgi_index  index.php;
    fastcgi_param  SCRIPT_FILENAME  $document_root$fastcgi_script_name;
    include        fastcgi_params;
}
```
document_root变量由root指定，默认root是html，应该改成绝对路径

### 3. php-fpm配置优化

1.防止request_terminate_timeout设置过长或者设置为0

request_terminate_timeout默认值为0秒，也就是说，PHP脚本会一直执行下去。对于file_get_contents之类的操作，如果卡主，会导致php-fpm进程全部消耗完，导致502。php-fpm应该设置超时时间，一般30s

另一方面，程序方面应该考虑设置超时时间：
```
$ctx = stream_context_create(array(  
   'http' => array(  
       'timeout' => 10 //设置一个超时时间，单位为秒  
       )  
   )  
);  
file_get_contents($str, 0, $ctx);
```
2.设置request_slowlog_timeout记录慢执行记录

经常出现的网络读取超过、Mysql查询过慢的问题，根据提示信息再排查问题就有很明确的方向了。