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

querystring = require('querystring')

module.exports = (robot) ->
  robot.router.get "/hubot/say", (req, res) ->
    console.log('about to ask operator, who owes money?')
    query = querystring.parse(req._parsedUrl.query)
    message = query.message

    user = {}
    user.room = query.room if query.room

    robot.send(user, message)
    res.end "said #{message}"