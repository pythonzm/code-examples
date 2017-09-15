@extends('layout')

@section('content')
	<div id="UserController" style="padding-top: 2em">
		<div class="alter alert-danger" v-if="!isValid">
			<ul>
				<li v-show="!validation.name">Name field is required</li>
				<li v-show="!validation.email">Input a valid email address</li>
				<li v-show="!validation.address">Address field is required</li>
			</ul>
		</div>
		<form action="#" @submit.prevent="addNewUser" method="POST">
			<div class="form-group">
				<label for="name">Name:</label>
				<input type="text" v-model="newUser.name" id="name" name="name" class="form-control">
			</div>

			<div class="form-group">
				<label for="email">Email:</label>
				<input type="text"  v-model="newUser.email" id="email" name="email" class="form-control">
			</div>

			<div class="form-group">
				<label for="address">Address:</label>
				<input v-model="newUser.address" type="text" id="address" name="address" class="form-control">
			</div>

			<div class="form-group">
				<button :disabled="!isValid" class="btn btn-default" type="submit" v-if="!edit">
					Add New Users
				</button>
				<button :disabled="!isValid" class="btn btn-default" type="submit" v-if="edit" @click="editUser(newUser.id)">Edit user</button>
			</div>
		</form>
		<hr/>

		<table class="table">
			<thead>
				<th>ID</th>
				<th>NAME</th>
				<th>EMAIL</th>
				<th>ADDRESS</th>
				<th>CREATED_AT</th>
				<th>UPDATE_AT</th>
				<th>CONTROLLER</th>
			</thead>
			<tbody>
				<tr v-for="user in users">
					<td> @{{ user.id }} </td>
					<td> @{{ user.name }} </td>
					<td> @{{ user.email }} </td>
					<td> @{{ user.address }} </td>
					<td> @{{ user.created_at }} </td>
					<td> @{{ user.updated_at }}  </td>
					<td>
						<button class="btn btn-default btn-sm" @click="showUser(user.id)">Edit</button>
						<button class="btn btn-danger btn-sm" @click="removeUser(user.id)">Remove</button>
					</td>
				</tr>
			</tbody>
		</table>
	</div>
@endsection

@push('scripts')
<script type="text/javascript" src="/js/scripts.js"></script>
@endpush