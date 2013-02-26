Gradient = require('./gradient')

class Colormap
  constructor: (map) ->
    @setMap(map)

  setMap: (map) ->
    switch map.type
      when "LUT"
        @map = map
        @loadLUT()
        true
      when "SAO"
        @map = map
        @loadSAO()
        true
      else false

  loadSAO: ->
    map = @map

    r = new Gradient()
    g = new Gradient()
    b = new Gradient()

    rLevel = map.red.level
    rIntensity = map.red.intensity
    gLevel = map.green.level
    gIntensity = map.green.intensity
    bLevel = map.blue.level
    bIntensity = map.blue.intensity

    for i in [0..rLevel.length-1]
      r.add(rLevel[i],rIntensity[i])
    for i in [0..gLevel.length-1]
      g.add(gLevel[i],gIntensity[i])
    for i in [0..bLevel.length-1]
      b.add(bLevel[i],bIntensity[i])
    
    r.build()
    g.build()
    b.build()

    @red = r
    @green = g
    @blue = b


  colorize: (stretchData,colorData) ->
    type = @map.type

    if type == "SAO"
      i = stretchData.length
      r = @red.gradient
      g = @green.gradient
      b = @blue.gradient
      while i--
        level = stretchData[i]
        colorData[i] = (255 << 24) | (level << 16) | (level << 8) | level
      undefined
  
  

module?.exports = Colormap
