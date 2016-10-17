# lest

Asynchronous, recursive `ls`

## Quickstart (CoffeeScript)

    lest = require './lib/lest'

    lest '/Users'
      .each ({entry, level, error}) ->
        spacer = if level <= 0 then '' else [1..level].map(() -> '  ').join ''
        console.log "#{spacer}#{entry || 'error: ' + error}"

## Local development

    npm install
    npm test

## Docs

### lest(path)

Inspect and list file/dir names under `path` (recursive)

**Arguments**

- `path`: Path to inspect

**Returns**

A [highlandjs](http://highlandjs.org) stream of objects of the following format:

    {
      name: ".git", // File/dir name
      error: null,  // Error message (if any)
      level: 0      // Directory depth relative to `path`
    }
