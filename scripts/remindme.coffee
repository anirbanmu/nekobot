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
      humanizedDuration = moment.duration(0).subtract(duration).humanize()
      if message == undefined
        msg.reply 'Here\'s your reminder from about ' + humanizedDuration + ' ago'
      else
        msg.reply message + ' (reminder set about ' + humanizedDuration + ' ago)'
    , duration.asMilliseconds()
    msg.reply 'I\'ll remind you in about ' + duration.humanize()
