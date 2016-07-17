# Description:
#   Example timing scripts
#
# Notes:
#   Correct the timezone!
#   They are commented out by default
#   Uncomment the ones you want to try and experiment with.
#
#   These are from the scripting documentation: https://leanpub.com/automation-and-monitoring-with-hubot/read#leanpub-auto-periodic-task-execution

Operator = require('./operator');

module.exports = (robot) ->
   cronJob = require('cron').CronJob
   tz = 'Australia/Sydney'
   new cronJob('0 0 6 * * 1-5', workdaysSixAm, null, true, tz)                            #6am workdays
   new cronJob('0 */1 * * * *', workdaysSixAm, null, true, tz)           #every 5 min
   new cronJob('00 25 14 * * 1-5', Operator.howMuchMoneyDoIHave(), null, true,tz)         #2:25pm workdays

   room = "testchannel"
 
   workdaysSixAm = ->
     robot.emit 'slave:command', 'wake everyone up', room
 
   everyFiveMinutes = ->
     robot.messageRoom room, 'I will nag you every minute'