/* 
----------------------------------------------------------------	
Author: Pawan Araballi  
----------------------------------------------------------------
*/

var express = require('express');
var user = express.Router();
var mysql = require('../models/mysql');
var verify_token = require('../models/verify');
var rn = require('random-number');

user.get('/DailyQuestions', function (req, res,next) {
console.log('DailyQuestions');


    verify_token.verify(req.query.token,function(err, decoded) {

        if(!err && decoded.tag == 'user') {
            mysql.DailyQuestions( function(model) {
                console.log(model);
                res.json({statusCode: 200, message : "Daily Questions", data: model});
            });
        }
        else{
            console.log(err);
            res.json({statusCode: 200, message : " invalid user ", data: null});
        }
    });


});

user.get('/WeeklyQuestions', function (req, res,next) {
    console.log('WeeklyQuestions');


    verify_token.verify(req.query.token,function(err, decoded) {

        if(!err && decoded.tag == 'user') {
            mysql.WeeklyQuestions( function(model) {
                console.log(model);
                res.json({statusCode: 200, message : "Weekly Questions", data: model});
            });
        }
        else{
            console.log(err);
            res.json({statusCode: 200, message : " invalid user ", data: null});
        }
    });

});

user.get('/Steps', function (req, res,next) {
    console.log('Steps');


    verify_token.verify(req.query.token,function(err, decoded) {

        if(!err && decoded.tag == 'user') {
            mysql.getSteps( function(model) {
                console.log(model);
                res.json({statusCode: 200, message : "Steps", data: model});
            });
        }
        else{
            console.log(err);
            res.json({statusCode: 200, message : " invalid user ", data: null});
        }
    });

});

user.get('/Appointments', function (req, res,next) {
   verify_token.verify(req.query.token,function(err, decoded) {

        if(!err && decoded.tag == 'user') {
            user = decoded.user;
            mysql.getAppointmentForUser( user,  function(model) {
                console.log(model);
                res.json({statusCode: 200, message : "Appointments", data: model});
            });
        }
        else{
            console.log(err);
            res.json({statusCode: 200, message : " invalid user ", data: null});
        }
    });

});

user.get('/AllDailyLogs', function (req, res,next) {
    console.log('DailyQuestions');


    verify_token.verify(req.query.token,function(err, decoded) {

        if(!err && decoded.tag == 'user') {
            user = decoded.user;
            mysql.getUserDailyLog(user, function(model) {
                var data = JSON.stringify(model);
                console.log(data);
                res.json({statusCode: 200, message : "DailyLog", data: model});
            });
        }
        else{
            console.log(err);
            res.json({statusCode: 200, message : " invalid user ", data: null});
        }
    });


});

user.get('/game', function (req, res,next) {
    console.log('game');


    verify_token.verify(req.query.token,function(err, decoded) {

        if(!err && decoded.tag == 'user') {
            user = decoded.user;

            mysql.getAllImageData(function (model) {
                console.log(model);

            })



        }
        else{
            console.log(err);
            res.json({statusCode: 200, message : " invalid user ", data: null});
        }
    });


});


user.post('/DailyLog', function (req, res,next) {
    console.log('Daily Response');



    verify_token.verify( req.get('token'), function (err, decoded) {

        if (!err && decoded.tag == 'user') {
            var data = req.body;
            data.username = decoded.user;
            var ImageData = {};
            var array =  [];
            ImageData.user = decoded.user;
            ImageData.image = data.ImageUrl;
            ImageData.userResponse = data.FoodAndDrinksConsumed;
            array.push(data.FoodAndDrinksConsumed);
            ImageData.responses = JSON.serialize(array);


            mysql.putUserDailyLog(data,function (model) {
                if(model == null){
                    res.json({statusCode : 200 , message:"data not stored"});
                }else{
                    mysql.putImageData(ImageData,function (model) {
                        if(model == null){
                            res.json({statusCode : 200 , message:"Image data not stored"});
                        }else{
                            res.json({statusCode : 200 , message:"Image data stored"});
                        }
                    });

                    res.json({statusCode : 200 , message:"data stored"});
                }
            })

        }
        else {
            console.log(err);
            res.json({statusCode: 200, message: " invalid user ", data: null});
        }
    });
});





user.post('/DailyActivities', function (req, res,next) {
    console.log('Daily Response');



    verify_token.verify( req.get('token'), function (err, decoded) {

        if (!err && decoded.tag == 'user') {
            var data = req.body;
            data.username = decoded.user;
            mysql.putUserDailyActivities(data,function (model) {
                if(model == null){
                    res.json({statusCode : 200 , message:"data not stored"})
                }else{
                    res.json({statusCode : 200 , message:"data stored"})
                }
            })

        }
        else {
            console.log(err);
            res.json({statusCode: 200, message: " invalid user ", data: null});
        }
    });
});


user.post('/WeeklyResponse', function (req, res,next) {
    console.log('Weekly Response');



    verify_token.verify( req.get('token'), function (err, decoded) {

        if (!err && decoded.tag == 'user') {
            var data = req.body;
            data.username = decoded.user;
            mysql.putUserWeeklyLog(data,function (model) {
                if(model == null){
                    res.json({statusCode : 200 , message:"data not stored"})
                }else{
                    res.json({statusCode : 200 , message:"data stored"})
                }
            })

        }
        else {
            console.log(err);
            res.json({statusCode: 200, message: " invalid user ", data: null});
        }
    });
});

module.exports = user;