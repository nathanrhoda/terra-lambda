let response;
const AWS = require('aws-sdk');
AWS.config.region = 'af-south-1';
var lambda = new AWS.Lambda();

exports.handler = function (event, context, callback) {    
    var params = {
        FunctionName: 'hello_node',
        InvocationType: 'RequestResponse',
        LogType: 'Tail',
        Payload: '{"name" : "' + event.name + '"}'
    };

    lambda.invoke(params, function(err, data){
        if(err) {
            context.fail(err);
        } else {
            context.succeed(data.Payload);
        }
    });
}