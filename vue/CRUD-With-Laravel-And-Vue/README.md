## Origin video tutorial
[curd with vue](https://www.youtube.com/watch?v=qA5PlSh1Qq8&t=736s)


## some import operate
```
composer create-project --prefer-dist laravel/laravel CRUD-With-Laravel-And-Vue
```

edit database/migrations/xx_create_users_table.php
```
php artisan migrate
```

edit database/factories/ModelFactory.php
```
php artisan tinker
factory('App\User', 10)->create();
```


```
npm install
npm install vue
npm install vue-resource
```

edit webpack.mix.js pack vue.js and vue-resource.js into vendor.js
```
npm run development 
```

## screenshot

![crud-with-laravel-and-vuejs](http://static.cyub.me/images/vue-examples/CRUD%20with%20Vue%20JS.png)

## vue
https://cn.vuejs.org/v2/guide/components.html#DOM-模版解析说明
vue父子组件关系`props down, events up`



