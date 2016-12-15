var jwt = require('jsonwebtoken');
var express = require('express');
var bcrypt = require('bcrypt');
var supporter = express.Router();
var mysql = require('../models/mysql');
var verify_token = require('../models/verify');

supporter.get('/home', function (req, res,next) {

    verify_token.verify(req.session.token,function(err, decoded) {

        console.log(decoded);
        if(!err && decoded.tag == 'supporter'){
            console.log(decoded.user);
            user = decoded.user;
            mysql.getUserForSupporter(user,function (model) {
                console.log(model);
                var data = JSON.stringify(model);
                res.render('pages/details',{data:data});
            });
        }else{
            console.log(err);
            user = null ;
            req.session.token = null ;
            res.render('pages/logout',{statusCode:200 , message : 'invalid session please login'});

        }
    });
});


supporter.get('/updateStep', function (req, res,next) {

    verify_token.verify(req.session.token,function(err, decoded) {

        console.log(decoded);
        if(!err && decoded.tag == 'supporter'){
            console.log(decoded.user);
            user = decoded.user;
            mysql.updateStep(req.query.username,req.query.step ,function(model){
            res.redirect('/progress');
            });
        }else{
            console.log(err);
            user = null ;
            req.session.token = null ;
            res.render('pages/logout',{statusCode:200 , message : 'invalid session please login'});

        }
    });
});

supporter.get('/notification', function (req, res,next) {

    verify_token.verify(req.session.token,function(err, decoded) {

        console.log(decoded);
        if(!err && decoded.tag == 'supporter'){
            console.log(decoded.user);
            supporter = decoded.user;
            var notdata = [];
            if(req.query.username) {
                mysql.getUser(req.query.username, function (model) {
                    if (model != null) {
                        var data = JSON.parse(JSON.stringify(model));
                        console.log(data);
                        if(data.notification == null){
                            notdata.push(req.query.data);
                            data.notification  = notdata;
                        }else{
                            notdata = data.notification;
                            notdata.push(req.query.data);
                        }
                        res.json({statusCode: 200, message: " data stored"});
                    }
                });
            }
            else{
                mysql.getUserForSupporter(supporter, function (model) {
                    if (model != null) {
                        var data = JSON.parse(JSON.stringify(model));
                        for (var i in data) {
                            if (data[i].notification == null) {
                                notdata.push(req.query.data);
                                data.notification = notdata;
                            } else {
                                notdata = data.notification;
                                notdata.push(req.query.data);
                            }
                            res.json({statusCode: 200, message: " data stored"});
                        }
                    }
                });
            }
        }else{
            console.log(err);
            user = null ;
            req.session.token = null ;
            res.render('pages/logout',{statusCode:200 , message : 'invalid session please login'});

        }
    });
});



supporter.get('/progress', function (req, res,next) {

    verify_token.verify(req.session.token,function(err, decoded) {

        if(!err && decoded.tag == 'supporter'){
            console.log(decoded.user);
            supporter = decoded.user;
            user = req.query.username;

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
                                res.render('pages/userscreen',{data:{WeeklyLog: WeeklyLog , DailyActivities :DailyActivities,DailyLog:DailyLog,UserDetails:UserDetails }})
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

//send notifications
supporter.get('/sendnotification', function (req, res,next) {

    var user = req.query.username;
    var message = req.query.message;

    verify_token.verify(req.session.token,function(err, decoded) {

        console.log(decoded);
        if(!err && decoded.tag == 'supporter'){

            supporter = decoded.user;
            console.log("user: "+user+" ; message: " + message);

            res.redirect('/supporter/home');
        }
        else{
            console.log(err);
            user = null ;
            req.session.token = null ;
            res.render('pages/logout',{statusCode:200 , message : 'invalid session please login'});

        }
    });
});



supporter.get('/appointments', function (req, res,next) {

    verify_token.verify(req.session.token,function(err, decoded) {

        console.log(decoded);
        if(!err && decoded.tag == 'supporter'){

            supporter = decoded.user;
            mysql.getAppointmentForSupporter(supporter,function (model) {
                console.log(model);
                var data = JSON.stringify(model);
                console.log(data);
                user = null;
                if(req.query.username) {
                     user = req.query.username;
                     console.log("user = " + user);
                }
                res.render('pages/app_list',{data : {user: user, supporter: data  }});

            });
            }
        else{
            console.log(err);
            user = null ;
            req.session.token = null ;
            res.render('pages/logout',{statusCode:200 , message : 'invalid session please login'});

        }
    });
});


supporter.get('/CreateAppointments', function (req, res,next) {

    verify_token.verify(req.session.token,function(err, decoded) {

        if(!err && decoded.tag == 'supporter'){

            supporter = decoded.user;
            var data  = {
                Time : req.query.Time,
                supporter : supporter,
                username : req.query.username
            };

            console.log(data);
            mysql.putAppointment(data , function (model) {
                if(model != null){
                    res.redirect('/supporter/appointments');
                }else{
                    res.render('pages/app_list');
                }
            });
        }
        else{
            console.log(err);
            user = null ;
            req.session.token = null ;
            res.render('pages/logout',{statusCode:200 , message : 'invalid session please login'});

        }
    });
});

supporter.get('/removeUser', function (req, res, next) {

    verify_token.verify(req.session.token,function(err, decoded) {

        if(!err && decoded.tag == 'supporter'){
            console.log(req.query.username);
            supporter = decoded.user;

            console.log("username: " + req.query.username);
            mysql.removeUser(req.query.username, function (model) {
                if(model != null){
                    //res.end();
                    res.send('0');
                }else{
                    res.render('pages/logout');
                }
            })
        }else{
            console.log(err);
            user = null ;
            req.session.token = null ;
            res.render('pages/logout',{statusCode:200 , message : 'invalid session please login'});

        }
    });
});

supporter.get('/removeAppointment', function (req, res,next) {

    verify_token.verify(req.session.token,function(err, decoded) {

        if(!err && decoded.tag == 'supporter'){
            console.log(req.query.Time);
            supporter = decoded.user;
            console.log("time =" + req.query.Time);
            var data  = {
                Time : req.query.Time,
                supporter : supporter
            };

            console.log(data);
            mysql.removeAppointment(data , function (model) {
                if(model != null){
                    //res.end();
                    res.redirect('/supporter/appointments');
                }else{
                    res.render('pages/app_list');
                }
            })
        }else{
            console.log(err);
            user = null ;
            req.session.token = null ;
            res.render('pages/logout',{statusCode:200 , message : 'invalid session please login'});

        }
    });
});



module.exports = supporter;