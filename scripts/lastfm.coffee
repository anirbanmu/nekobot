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
  robot.hear /^now\s*playing\s*(\S*)/i, (msg) ->
    lastfm = new LastFmNode (
      {
        api_key: process.env.HUBOT_LASTFM_APIKEY,
        secret: process.env.HUBOT_LASTFM_SECRET
      }
    )

    lastfm.request(
      'user.getRecentTracks',
      {
        user: if msg.match[1] then msg.match[1] else msg.message.user.name,
        limit: 2,
        extended: 1,
        handlers: {
          success: (data) ->
            msg.reply latest(data.recenttracks)
          error: (error) ->
        }
      }
    )

latest = (tracks) ->
  reply = tracks['@attr'].user
  track = tracks.track[0]

  nowPlaying = track['@attr'] != undefined && track['@attr'].nowplaying == 'true'
  if nowPlaying
    reply += ' is currently listening to '
  else
    reply += ' most recently listened to '
  reply += track.name + ' by ' + track.artist.name

  if !nowPlaying && track.date != undefined
    reply += ' on ' + track.date['#text'] + ' (UTC)'

  reply += ' - ' + track.url

  return reply