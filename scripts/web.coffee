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
  robot.router.get "/hubot/xero/:room", (req, res) ->
    console.log('web call has been received')
    robot.emit 'whoowes', (res)