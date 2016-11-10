/*
 ----------------------------------------------------------------
 Author: Pawan Araballi
 ----------------------------------------------------------------
 */

var express = require('express');
console.log('questions.js');
var appointment = express.Router();
var mysql = require('../models/mysql');
var verify_token = require('../models/verify');


appointment.get('/', function (req, res,next) {

    verify_token.verify(req.session.token,function(err, decoded) {

        console.log(decoded);
        if(!err && decoded.tag == 'supporter'){
            res.render('pages/appointments',{data : req.query.username});
            }
        else{
            console.log(err);
            user = null ;
            req.session.token = null ;
            res.render('pages/logout',{statusCode:200 , message : 'invalid session please login'});

        }
    });
});

appointment.post('/', function (req, res,next) {

    verify_token.verify(req.session.token,function(err, decoded) {

        if(!err && decoded.tag == 'supporter'){
            console.log(req.body);
            supporter = decoded.user;
            var data  = req.body;
            mysql.getAppointment(data , function (model) {
                if(model != null){
                    res.redirect('/supporter/home');
                }else{
                    res.render('pages/appointments');
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
module.exports = appointment;