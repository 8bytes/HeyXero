# Description:
#   Example commands from web
#
# Notes:
#   
#
#   This is from the scripting documentation: https://github.com/michikono/slackbot-tutorial/blob/master/scripts/slackbot-examples.coffee

Operator = require('./operator');
_ = require('lodash');

module.exports = (robot) ->
   robot.router.post '/hubot/xero/#testchannel', (req, res) ->
      room =req.params.room
      robot.messageRoom room, "a test"
#      robot.emit 'topfive', (res)

#        robot.emit "summary", {

      # note the REMOVE THIS PART in this example -- since we are using a GET and the link is being published in the chat room
      # it can cause an infinite loop since slack itself pre-fetches URLs it sees
# source: "a HTTP call to #{process.env.HEROKU_URL or ''}[]/hubot/xero/#{req.params.room} (could be any room name)"
#    }
    # reply to the browser
    res.send 'OK'
