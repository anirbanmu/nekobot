# Description:
#   Pings user with a reminder. Note: the reminders are lost after bot is restarted
#
# Dependencies:
#   None
#
# Configuration:
#   None
#
# Commands:
#   `nekobot remindme [hh:mm|hh:mm:ss] [optional msg]` to be pinged after specified time period
#

moment = require('moment')

module.exports = (robot) ->
  robot.respond /remindme\s+([\d:]+)(\s+(.*)+)?/i, (msg) ->
    duration = moment.duration(msg.match[1])
    message = msg.match[3]
    setTimeout () ->
      humanizedDuration = moment.duration(0).subtract(duration).humanize(true)
      if message == undefined
        msg.reply 'Here\'s your reminder from ' + humanizedDuration
      else
        msg.reply message + ' (reminder set ' + humanizedDuration + ')'
    , duration.asMilliseconds()
