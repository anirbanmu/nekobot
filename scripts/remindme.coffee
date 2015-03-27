# Description:
#   Pings user with a reminder
#
# Dependencies:
#   None
#
# Configuration:
#   None
#
# Commands:
#   `nekobot remindme hh:mm [optional msg]` to be pinged in hh:mm
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
