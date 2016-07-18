# Description:
#   Example timing scripts
#
# Notes:
#   Correct the timezone!
#   They are commented out by default
#   Uncomment the ones you want to try and experiment with.
#   Ensure you set the room to use by default 
#   If you are using Heroku they have a scheduler that runs instead of this file
#
#   These are from the scripting documentation: https://leanpub.com/automation-and-monitoring-with-hubot/read#leanpub-auto-periodic-task-execution


module.exports = (robot) ->
   cronJob = require('cron').CronJob
   tz = 'Australia/Sydney'
   new cronJob('0 0 6 * * 1-5', workdaysSixAm, null, true, tz)              #6am workdays
   new cronJob('0 */5 * * * *', everyFiveMinutes, null, true, tz)           #every 5 min
   new cronJob('00 25 14 * * 1-5', workdaysSixPm, null, true, tz)           #6pm workdays

   room = "%23testchannel"
 
   workdaysSixAm = ->
      robot.emit 'summary', (res)
 
   workdaysSixPm = ->
      robot.emit 'howmuch', (res)
 
   everyFiveMinutes = ->
      console.log('about to check if CRON working!')
#     robot.messageRoom room, 'I will nag you every 5 minutes'