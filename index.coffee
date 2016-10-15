lest = require './lib/lest'

lest '/Users'
  .each ({entry, level, error}) ->
    spacer = if level <= 0 then '' else [1..level].map(() -> '  ').join ''
    console.log "#{spacer}#{entry || 'error: ' + error}"
