# Description:
#   Example timing scripts
#
# Notes:
#   Correct the timezone!
#   They are commented out by default
#   Uncomment the ones you want to try and experiment with.
#
#   These are from the scripting documentation: https://leanpub.com/automation-and-monitoring-with-hubot/read#leanpub-auto-periodic-task-execution

module.exports = (robot) ->
   cronJob = require('cron').CronJob
   tz = 'Australia/Sydney'
   new cronJob('0 0 6 * * 1-5', workdaysSixAm, null, true, tz)
   new cronJob('0 */5 * * * *', everyFiveMinutes, null, true, tz)
 
   room = "#finance"
 
   workdaysSixAm = ->
     robot.emit 'slave:command', 'wake everyone up', room
 
   everyFiveMinutes = ->
     robot.messageRoom room, 'I will nag you every 5 minutes'