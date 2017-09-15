<?php

/*
|--------------------------------------------------------------------------
| API Routes
|--------------------------------------------------------------------------
|
| Here is where you can register API routes for your application. These
| routes are loaded by the RouteServiceProvider within a group which
| is assigned the "api" middleware group. Enjoy building your API!
|
*/

Route::get('/users', function () {
	return App\User::orderBy('id', 'desc')->get();
});

Route::post('/users', function () {
	return App\User::create(Request::all());
});

Route::get('/users/{id}', function ($id) {
	return App\User::findOrFail($id);
});

Route::patch('/users/{id}', function($id) {
	App\User::findOrFail($id)->update(Request::all());

	return Response::json(Request::all());
});

Route::delete('/users/{id}', function ($id) {
	return App\User::destroy($id);
});
