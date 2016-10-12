# lest

Asynchronous, recursive `ls`

## Quickstart

    const lest = require('lest')

    lest(__dirname, (err, basenames, partialErrors) => {
      if (err) throw err

      console.log(basenames)

      if (!partialErrors.length) return
      console.error('Errors were encountered whilst inspecting ' + __dirname)
      partialErrors.forEach(console.log)
    })

## Docs

### lest(path, done)

Inspect and list basenames under `path` (recursive)

#### Arguments

- `path`: Path to inspect
- `done(err, basenames, partialErrors)`
  - `err`: Error (if any)
  - `basenames`: An array of basenames under `path`. Ordering and uniqueness not guaranteed
  - `partialErrors`: An array of `LestPartialError`s encountered during inspection

### LestPartialError (extends Error)

A partial error encountered during `lest` inspection

#### Additional properties

- `path`: The path being inspected when the error occured
