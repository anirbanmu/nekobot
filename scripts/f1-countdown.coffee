# Description:
#   F1 Countdown
#
# Dependencies:
#   ical, moment
#
# Configuration:
#   None
#
# Commands:
#   hubot countdown - Responds with time left until next F1 event
#

ical = require('ical')
moment = require('moment')

module.exports = (robot) ->
  robot.respond /countdown/i, (msg) ->
    currentTime = moment()
    upcomingEvent = undefined
    ical.fromURL(
      'https://www.google.com/calendar/ical/hendnaic1pa2r3oj8b87m08afg%40group.calendar.google.com/public/basic.ics', 
      {}, 
      (err, data) -> 
        for own k, ev of data
          eventTime = moment(ev.start)
          if currentTime.isBefore(eventTime)
            if upcomingEvent == undefined
              upcomingEvent = ev
            else
              if eventTime.isBefore(upcomingEvent.start)
                upcomingEvent = ev
        diff = moment.duration(moment(upcomingEvent.start).diff(currentTime))
        result = upcomingEvent.summary + ' starts in '
        result += Math.floor(diff.asDays()).toString() + ' days '
        result += diff.hours().toString() + ':' + pad2(diff.minutes().toString()) + ':' + pad2(diff.seconds().toString())
        msg.reply result
      )

pad = (n, width, z) ->
  z = z || '0'
  n = n + ''
  return if n.length >= width then n else new Array(width - n.length + 1).join(z) + n
  
pad2 = (n) -> return pad(n, 2, '0')

