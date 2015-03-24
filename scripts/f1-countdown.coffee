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
    currentEvent = undefined
    ical.fromURL(
      'https://www.google.com/calendar/ical/hendnaic1pa2r3oj8b87m08afg%40group.calendar.google.com/public/basic.ics', 
      {}, 
      (err, data) -> 
        for own k, ev of data
          eventTime = moment(ev.start)
          if eventTime.isAfter(currentTime)
            if currentEvent == undefined
              currentEvent = ev
            else
              if moment(currentEvent.start).isAfter(eventTime)
                currentEvent = ev
        diff = moment.duration(moment(currentEvent.start).diff(currentTime))
        result = currentEvent.summary + ' starts in '
        result += Math.floor(diff.asDays()).toString() + ' days '
        result += diff.hours().toString() + ':' + diff.minutes().toString() + ':' + diff.seconds().toString()
        msg.reply result
      )

