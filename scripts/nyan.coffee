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

nyanMatchString = 
  nyan.map (string) ->
    '|'+string
  .join '' 

nyanRegExp = new RegExp("nekobot" + nyanMatchString, "i")

module.exports = (robot) ->
  robot.hear nyanRegExp, (msg) ->
    sound = msg.random nyan
    msg.emote '_' + sound + '_'
