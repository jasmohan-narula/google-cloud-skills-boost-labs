const functions = require('@google-cloud/functions-framework');
functions.cloudEvent('cs-logger', (cloudevent) => {
  console.log('A new event in your Cloud Storage bucket has been logged!');
  console.log(cloudevent);
});