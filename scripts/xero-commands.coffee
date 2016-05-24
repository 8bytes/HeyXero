# Description:
#   Example scripts for you to examine and try out.
#
# Commands:
#   invoice <contact> for <amount> of <description> - creates a draft invoice
#
# Notes:
#   They are commented out by default, because most of them are pretty silly and
#   wouldn't be useful and amusing enough for day to day huboting.
#   Uncomment the ones you want to try and experiment with.
#
#   These are from the scripting documentation: https://github.com/github/hubot/blob/master/docs/scripting.md
Operator = require('./operator');
_ = require('lodash');

module.exports = (robot) ->

  robot.respond(/i need money/i, (res) ->
  	console.log('they want help')
  	res.reply('It looks like you need some more capital... finweb coming soon!')
  )

  robot.respond(/invoice (.*) for (.*) of (.*)/i, (res) ->
    contactName = res.match[1]
    unitAmount = res.match[2]
    description = res.match[3]
    console.log("about to ask the operator to invoice #{contactName} for #{unitAmount} of #{description}")
    Operator.invoiceSomebody(contactName, description, unitAmount).then(
      (result) ->
        res.reply(result)
      (err) ->
        console.log('Something has gone wrong :( ' + err)
        res.reply("I'm not sure.")
    )

  )
