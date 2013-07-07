revbin = require('./bitreverse')

arrayutils =
  max: (array) ->
    max = -Infinity
    i = array.length
    while i--
      if array[i] > max
        max = array[i]
    max

  min: (array) ->
    min = Infinity
    i = array.length
    while i--
      if array[i] < min
        min = array[i]
    min

  revbin_permute: (array,n) ->
    ldn = Math.log(n)/Math.LN2
    for x in [0..n-1]
      r = revbin(x,ldn)
      if r > x
        temp = array[x]
        array[x] = array[r]
        array[r] = temp
    undefined

  shift_to_zero: (array) ->
    max = -Infinity
    min = Infinity
    i = array.length
    while i--
      value = array[i]
      if value > max
        max = value
      if value < min
        min = value

    i = array.length

    if min != 0
      while i--
        array[i] = array[i] - min

    undefined

  normalize_to_one: (array) ->
    total = 0
    i = array.length
    while i--
      total = total + array[i]

    inv_total = 1 / total
    i = array.length
    while i--
      array[i] = array[i]*inv_total

    undefined

module?.exports = arrayutils
