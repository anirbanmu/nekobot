# Description:
#   Emits kitteh noises when nekobot hears its name
#
# Dependencies:
#   None
#
# Configuration:
#   None
#
# Commands:
#   mention nekobot to trigger
#

nyan = [
  'meow',
  'miaaau',
  'miao',
  'miaou',
  'purr',
  'nyan', #japanese
  'nya',
  'nyao',
  'myah',
  'goro goro',
  'ニャーニャー',
  'ニャー',
  'ニャン', 
  'ニャーン', 
  'ニャーオ',
  'ごろごろ',
  'nyaong', #korean
  'yaong',
  ]

module.exports = (robot) ->
  robot.hear /nekobot/i, (msg) ->
    sound = nyan[Math.floor(Math.random() * nyan.length)]
    msg.emote '_' + sound + '_'
