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
#   hubot countdown - Responds with time left until next F1 event or displays time until end of in-session F1 event.
#   hubot countdownNext - Responds with time left until next F1 event.
#

ical = require('ical')
moment = require('moment')

module.exports = (robot) ->
  robot.respond /countdown(next)*/i, (msg) ->
    countdown(msg, msg.match[1] == undefined)

countdown = (msg, reportInSession) ->
  currentTime = moment()
  
  closestEvent =
    ev: undefined,
    inSession: false

  ical.fromURL(
    'https://www.google.com/calendar/ical/hendnaic1pa2r3oj8b87m08afg%40group.calendar.google.com/public/basic.ics', 
    {},
    (err, data) ->
      for own k, ev of data
        eventStartTime = moment(ev.start)

        if reportInSession && ev.end != undefined
          inSession = currentTime.isBetween(ev.start, ev.end)
          if inSession
            closestEvent.inSession = true
            closestEvent.ev = ev
            break

        if currentTime.isBefore(eventStartTime)
          if closestEvent.ev == undefined
            closestEvent.ev = ev
          else
            if eventStartTime.isBefore(closestEvent.ev.start)
              closestEvent.ev = ev

      msg.reply composeReply(closestEvent, currentTime) 
    )

composeReply = (event, currentTime) ->
  reply = event.ev.summary
  if event.inSession
    reply += ' is in session & will end in '
    diff = moment.duration(moment(event.ev.end).diff(currentTime))
  else
    reply += ' starts in '
    diff = moment.duration(moment(event.ev.start).diff(currentTime))

  reply += Math.floor(diff.asDays()).toString() + ' days '
  reply += diff.hours().toString() + ':' + pad2(diff.minutes().toString()) + ':' + pad2(diff.seconds().toString())
  return reply

pad = (n, width, z) ->
  z = z || '0'
  n = n + ''
  return if n.length >= width then n else new Array(width - n.length + 1).join(z) + n
  
pad2 = (n) -> return pad(n, 2, '0')

