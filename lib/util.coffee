# Creates a function which will call `fn`, but with added timeout behaviour
# If timeout is reached, an error will be returned
forceTimeout = (fn, timeout, {errorMessage}) ->
  (args...) ->
    hasCallback = args.length > 0 and typeof args[args.length - 1] == 'function'
    done = if hasCallback then args[args.length - 1] else null
    args.pop() if hasCallback

    # A. Callback wasn't supplied -- don't do anything differently
    fn.apply this, args unless hasCallback

    # B. Otherwise, start a race between
    resolved = false
    timer = null

    # B1. The function running to completion
    args.push (args...) ->
      return if resolved
      clearTimeout timer
      resolved = true
      done.apply this, args
    res = fn.apply this, args

    # B2. Timeout error after a delay
    setTimeout () ->
      return if resolved
      resolved = true
      err = new Error errorMessage
      err.args = args
      done err
    , timeout

    res

module.exports = {forceTimeout}
