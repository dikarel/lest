module.exports = ({failOn, timeoutOn}) ->
  fs = require 'fs'

  stat = (path, done) ->
    return done(new Error 'some error') if path == failOn
    return fs.stat path, done unless path == timeoutOn
    setTimeout (() -> fs.stat path, done), 3000

  {readdir: fs.readdir, stat}
