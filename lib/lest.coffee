{forceTimeout} = require './util'
fs = require './faulty-fs'
{join} = require 'path'
h = require 'highland'

# Force a time limit for fs functions
readdir = h.wrapCallback forceTimeout fs.readdir, 1000,
  errorMessage: 'fs.readdir timed out'
getStat = h.wrapCallback forceTimeout fs.stat, 1000,
  errorMessage: 'fs.stat timed out'

# Return a stream of file/dir entries under a path (recursive)
# Resulting entries are not flattened
dirStream = (path, level) ->

  # For each child entry under `path`
  readdir path
    .map (entries) ->
      h(entries).flatMap (entry) ->
        fullPath = join path, entry
        [
          # Emit an entry
          h.of entry: entry, level: level

          # Recurse if directory
          getStat fullPath
            .map (stat) ->
              return [] unless stat.isDirectory()
              dirStream(fullPath, level + 1)
            .errors (err, push) -> push null, {error: err.message, level: level + 1}
        ]
      .parallel Math.max 1, entries.length
  .errors (err, push) -> push null, {error: err.message, level: level}

# Return a stream of file/dir entries under a path (recursive)
# Each entry will have the format {entry, error, level}
# Symbolic links will be treated as regular files
lest = (path) ->
  h.of entry: path, level: 0
    .concat dirStream path, 1
    .flatten()

module.exports = lest
