var emailRE = /^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$/
var vm = new Vue({
	http: {
		root: '/root',
		headers: {
			'X-CSRF-TOKEN' : document.getElementById('token').getAttribute('value')
		}
	},
	el: '#UserController',
	data: {
		'users' : [],
		'newUser': {
			id: '',
			name:'',
			email: '',
			address: ''
		},
		edit: false
	},
	methods: {
		resetUser: function () {
			var oldUser = this.newUser;
			this.newUser = {
				id: '',
				name: '',
				email: '',
				address: ''
			}
			return oldUser;
		},
		
		fetchUser: function () {
			this.$http.get('/api/users').then(response => {
				this.users =  response.body;
			});
		},

		showUser: function (id) {
			this.edit = true
			this.$http.get('/api/users/' + id).then(response => {
				this.newUser.id = response.body.id
				this.newUser.name = response.body.name
				this.newUser.email = response.body.email
				this.newUser.address = response.body.address
			})
		},

		editUser: function (id) {
			var user = this.resetUser();
			this.$http.patch('/api/users/' + id, user).then(response => {
				this.fetchUser();
				this.edit = false
			})
		},

		addNewUser: function () {
			// clear form input
			var user = this.resetUser()

			// send post request
			this.$http.post('/api/users', user)

			// reload user lsit
			this.fetchUser()
		},

		removeUser: function(id) {
			var confirmBox = confirm("Are you sure, you want to delete this users")
			if (confirmBox) {
				this.$http.delete('/api/users/' + id).then(response => {
					this.fetchUser();
				})
			}
		}
	},
	computed: {
		validation: function () {
			return {
				name: !!this.newUser.name.trim(),
				email: emailRE.test(this.newUser.email),
				address: !!this.newUser.address.trim()
			}
		},
		isValid: function () {
			var validation = this.validation
			return Object.keys(validation).every(function(key) {
				return validation[key]
			})
		},
		testOk: function () {
			console.log('testok')
			return 'ok';
		}
	},
	created: function () {
		this.fetchUser();
	}
});