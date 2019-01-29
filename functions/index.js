'use strict';

const functions = require('firebase-functions');
const express = require('express');
const app = express();

const cors = require('cors')({origin: true});
app.use(cors);

app.get('/', (req, res) => {
  res.json({ status: 'OK' });
});

app.get('/:package', (req, res) => {
  res.json( req.params );
});

exports.app = functions.https.onRequest(app);
