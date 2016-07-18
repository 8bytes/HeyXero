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
    console.log('about to ask operator, who owes money?')
    robot.emit 'whoowes', (res)
    message=res
    user = {}
    user.room = query.room if query.room

    robot.send(message)
    res.end "said #{message}"