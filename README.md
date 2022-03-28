 
 
 aws lambda invoke --function-name hello_lambda out.txt 

aws lambda invoke --function-name who-am-i-greeting --payload '{ name: MONO }' who.txt  

aws lambda invoke --function-name who_am_i_greeting --cli-binary-format raw-in-base64-out --payload '{\"name\": \"MONO\"}' a.txt