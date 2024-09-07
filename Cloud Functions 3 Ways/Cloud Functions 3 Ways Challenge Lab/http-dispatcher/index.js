const functions = require('@google-cloud/functions-framework');
functions.http('http-dispatcher', (req, res) => {
  res.status(200).send('HTTP function (2nd gen) has been called!');
});