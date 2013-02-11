utils = require('./utils')

stretches =
  linear: (imageData,stretchData,min,max) ->
    range = max - min
    index = 0
    for i in [0..(stretchData.length - 1)]
      stretchData[i] = ~~(255*((imageData[i] - min)/range))
    undefined

  log: (imageData,stretchData,min,max) ->
    range = max - min
    max_log = Math.log(range)/Math.LN10

    for i in [0..(stretchData.length - 1)]
      stretchData[i] = ~~(255*((Math.log(imageData[i] - min + 1)/Math.LN10)/max_log))
    undefined

  power: (imageData, stretchData) ->
    undefined

module?.exports = stretches
