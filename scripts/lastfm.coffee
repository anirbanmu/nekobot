# Description:
#   Display last.fm now playing/most recent information
#
# Dependencies:
#   lastfm
#
# Configuration:
#   HUBOT_LASTFM_APIKEY
#   HUBOT_LASTFM_SECRET
#
# Commands:
#   now playing <username> - Fetches current playing or most recently played track by username specified.
#

LastFmNode = require('lastfm').LastFmNode

module.exports = (robot) ->
  robot.hear /^now\s*playing\s*(\S+)/i, (msg) ->
    lastfm = new LastFmNode (
      {
        api_key: process.env.HUBOT_LASTFM_APIKEY,
        secret: process.env.HUBOT_LASTFM_SECRET
      }
    )

    lastfm.request(
      'user.getRecentTracks',
      {
        user: msg.match[1],
        limit: 2,
        extended: 1,
        handlers: {
          success: (data) ->
            tracks = data.recenttracks
            track = tracks.track[0]
            robot.http(track.url)
              .get() (err, res, body) ->
                msg.reply latest(tracks['@attr'].user, track) + ' - ' + bestLink(track.url, body)
          error: (error) ->
        }
      }
    )

latest = (user, track) ->
  reply = user

  nowPlaying = track['@attr'] != undefined && track['@attr'].nowplaying == 'true'
  if nowPlaying
    reply += ' is currently listening to '
  else
    reply += ' most recently listened to '
  reply += track.name + ' by ' + track.artist.name

  if !nowPlaying && track.date != undefined
    reply += ' on ' + track.date['#text'] + ' (UTC)'

  return reply

bestLink = (baseURL, rawHTML) ->
  youtube = rawHTML.match /data-youtube-player-id="(.*?)"/i
  if youtube
    return 'http://www.youtube.com/watch?v=' + youtube[1]
  return baseURL