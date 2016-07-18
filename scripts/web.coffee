# Description:
#   Example commands from web
#
# Notes:
#   
#
#   This is from the scripting documentation: https://github.com/michikono/slackbot-tutorial/blob/master/scripts/slackbot-examples.coffee
Promise = require("bluebird");
Operator = require('./operator');
_ = require('lodash');


module.exports = (robot) ->
  robot.router.get "/hubot/say", (req, res) ->
    console.log('web call has been received')
  robot.on 'whoowes', (res) ->
    console.log('about to ask operator, who owes money?')
    Operator.whoOwesMoney().then(
      (result) ->
        res.reply('\n' + _.join(result, '\n'))
      (r) ->
        console.log('Something has gone wrong :( ' + r)
        res.reply("I'm not sure, how about you ask who owes money again later?")
    )