#Contains utility functions used by the library.
utils =
  #Returns the maximum value of an array.
  max: (array) ->
    max = -Infinity
    length = array.length
    for i in [0..(length-1)]
      if array[i] > max
        max = array[i]
    max
  
  #Returns the mininum value of an array.
  min: (array) ->
    min = Infinity
    length = array.length
    for i in [0..(length-1)]
      if array[i] < min
        min = array[i]
    min

module?.exports = utils
