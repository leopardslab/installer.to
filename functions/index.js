'use strict';

const functions = require('firebase-functions');
const express = require('express');
const {Storage} = require('@google-cloud/storage');


const app = express();
const storage = new Storage();
const bucket = storage.bucket('installer-to.appspot.com');

app.get('/', (req, res) => {
    res.set('Content-Type', 'application/json');
    res.json({ status: 'OK' });
});

app.get('/health', (req, res) => {
    res.set('Content-Type', 'application/json');
    res.json({ status: 'OK' });
});

app.get('/:package', (req, res) => {
    try {
        const minParam = req.query.min;
        const withParam = req.query.with;
        const fileName = ['installer'];

        if (minParam){
            fileName.push('min');
        }
        if (withParam){
            fileName.push(withParam);
        }
        fileName.push('sh');
        const fileNameString = fileName.join(".");
        const file = bucket.file(req.params.package + '/'+fileNameString);
        res.set('Content-Type', 'text/plain');
        const readStream = file.createReadStream();
        readStream.pipe(res);
    } catch (e) {
        res.send(e);
    }
});

exports.app = functions.https.onRequest(app);
