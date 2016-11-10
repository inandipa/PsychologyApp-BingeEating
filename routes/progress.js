
var jwt = require('jsonwebtoken');
var express = require('express');
var bcrypt = require('bcrypt');
var admin = express.Router();
var mysql = require('../models/mysql');
var verify_token = require('../models/verify');

admin.get('/', function (req, res,next) {

    verify_token.verify(req.session.token,function(err, decoded) {

        if(!err && decoded.tag == 'supporter'){
            console.log(decoded.user);
            supporter = decoded.user;
            user = req.query.user;

            mysql.getUserWeeklyLog(user,function (model) {
                if(model != null){
                    console.log( JSON.stringify(model));
                    var WeeklyLog = JSON.stringify(model);
                }
                mysql.getUserDailyActivities(user,function (model) {
                    if(model != null){
                        console.log( JSON.stringify(model));
                        var DailyActivities = JSON.stringify(model);
                    }
                    mysql.getUserDailyLog(user,function (model) {
                        if(model != null){
                            console.log( JSON.stringify(model));
                            var DailyLog = JSON.stringify(model);
                        }
                        mysql.getUser(user,function (model) {
                            if(model != null){
                                console.log( JSON.stringify(model));
                                var UserDetails = JSON.stringify(model);
                                res.render('pages/test',{data:{WeelyLog: WeeklyLog , DailyActivities :DailyActivities,DailyLog:DailyLog,UserDetails:UserDetails }})
                            }
                        });
                    });
                });
            });
        }else{
            console.log(err);
            user = null ;
            req.session.token = null ;
            res.render('pages/logout',{statusCode:200 , message : 'invalid session please login'});

        }
    });
});



module.exports = admin;