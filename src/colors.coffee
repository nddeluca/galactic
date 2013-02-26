Colormap = require('./colormap')

colors =
  grayscale: (stretchData,colorData) ->
    i = stretchData.length
    while i--
      value = stretchData[i]
      colorData[i] = (255 << 24) | (value << 16) | (value << 8) | value
    undefined

  heat: (stretchData,colorData) ->
    map = new Colormap('heat')
    i = stretchData.length
    while i--
      colorData[i] = map.getValue(stretchData[i])

module?.exports = colors
