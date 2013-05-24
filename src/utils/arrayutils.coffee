revbin = require('./bitreverse')

#Contains utility functions used by the library.
arrayutils =
  #Returns the maximum value of an array.
  max: (array) ->
    max = -Infinity
    i = array.length
    while i--
      if array[i] > max
        max = array[i]
    max

  #Returns the mininum value of an array.
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

module?.exports = arrayutils
