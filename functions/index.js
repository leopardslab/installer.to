'use strict';

const functions = require('firebase-functions');
const express = require('express');
const {Storage} = require('@google-cloud/storage');


const app = express();
const storage = new Storage();
const bucket = storage.bucket('installer-to.appspot.com');

app.get('/', (req, res) => {
  res.json({ status: 'OK' });
});

app.get('/:package', (req, res) => {
    try {
        const file = bucket.file(req.params.package + '/installer.sh');
        res.set('Content-Type', 'text/plain');
        const readStream = file.createReadStream();
        readStream.pipe(res);
    } catch (e) {
        res.send(e);
    }
});

exports.app = functions.https.onRequest(app);
