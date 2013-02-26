Gradient = require('./gradient')

class Colormap
  constructor: (map) ->
    @buffer = new ArrayBuffer(256*4)
    @pixelMap = new Uint32Array(@buffer)
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

  loadLUT: ->
    map = @map

    length = map.red.length
    increment = 256/length

    r = (new Gradient()).gradient
    g = (new Gradient()).gradient
    b = (new Gradient()).gradient

    
   

  loadSAO: ->
    map = @map
    pixelMap = @pixelMap

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
    @blue = b
    @green = g

    i = 256
    while i--
      pixelMap[i] = (255 << 24) | (b.gradient[i] << 16) | (g.gradient[i] << 8) | r.gradient[i]

    undefined

  colorize: (stretchData,colorData) ->
    type = @map.type
    if type == "SAO"
      i = stretchData.length
      r = @red.gradient
      g = @green.gradient
      b = @blue.gradient
      while i--
        level = stretchData[i]
        colorData[i] = (255 << 24) | (b[level] << 16) | (g[level] << 8) | r[level]
      undefined
  
  

module?.exports = Colormap
