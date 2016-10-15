fs = require 'fs'

maxDelay = 1100

# Creates a function which will call `fn`, but with added delay
withDelay = (fn) ->
  (args...) ->
    setTimeout (() -> fn.apply null, args), Math.random() * maxDelay

# fs functions with added delay
module.exports =
  readdir: withDelay fs.readdir
  stat: withDelay fs.stat
