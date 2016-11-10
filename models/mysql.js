
var bcrypt = require('bcrypt');
var mysql = require('mysql');
var saltRounds = 5;
var knex = require('knex')({
	client:'mysql',
	connection: {
		host : 'mydbase.cwgnanpueibv.us-east-1.rds.amazonaws.com',
      	user : 'indra',
      	password : 'qqqqqqqq',
      	port : '3306',
      	database: "BingeEating"
	}
});

var bookshelf = require('bookshelf')(knex);
 
var DailyQuestion = bookshelf.Model.extend({
  tableName: 'DailyQuestion'
});
var WeeklyQuestion = bookshelf.Model.extend({
	tableName: 'WeeklyQuestion'
});
var DailyLog = bookshelf.Model.extend({
    tableName: 'DailyLog'
});
var DailyPhysicalActivity = bookshelf.Model.extend({
    tableName: 'DailyPhysicalActivity'
});
var WeeklySummarySheet = bookshelf.Model.extend({
    tableName: 'WeeklySummarySheet'
});

var Admin = bookshelf.Model.extend({
  tableName: 'Admin'
});
var Supporter = bookshelf.Model.extend({
  tableName: 'Supporter'
});
var User = bookshelf.Model.extend({
  tableName: 'User'
});
var Login = bookshelf.Model.extend({
	tableName: 'Login'
});

module.exports.DailyQuestions = function(callback) {
new DailyQuestion()
.fetchAll()
.then(callback);
}

module.exports.WeeklyQuestions = function(callback) {
    new WeeklyQuestion()
        .fetchAll()
        .then(callback);
}

module.exports.getLoginDetails = function(user,callback) {
	console.log(user);
	new Login({username: user })
		.fetch()
		.then(callback);
}
module.exports.putLoginDetails = function(data,callback) {
	data.password = bcrypt.hashSync(data.password, saltRounds);
	console.log(data);
	new Login(data).save()
		.then(callback);
}


module.exports.getAdmin = function(user,callback) {
new Admin({email: user })
.fetch()
.then(callback);
}

module.exports.getSupporter = function(user,callback) {
new Supporter({email: user })
.fetch()
.then(callback);
}

module.exports.getAllSupporter = function(callback) {
	new Supporter()
		.fetchAll()
		.then(callback);
}
module.exports.getUser = function(user,callback) {
	new User({username: user })
		.fetch()
		.then(callback);
}
module.exports.putSupporter = function(user,callback) {
	console.log(user.username);

	new Supporter(user).save()
		.then(callback);

}

module.exports.getUserForSupporter = function(user,callback) {
	console.log(user);

	new User().where({supporter : user}).fetchAll().then(callback);
}

module.exports.putUser = function(user,callback) {

	console.log(user.username);

	new User(user).save()
		.then(callback);
}

module.exports.getUserDailyLog = function(data,callback){
    new DailyLog(data).save().then(callback);
}
module.exports.getUserDailyActivities = function(data,callback){
    new DailyPhysicalActivity(data).save().then(callback);
}
module.exports.getUserWeeklyLog = function(data,callback){
    new WeeklySummarySheet(data).save().then(callback);
}

