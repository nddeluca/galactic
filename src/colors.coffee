colors =
  #grayscale: (stretchData,colorData) ->
    #i = stretchData.length
    #while i--
      #value = stretchData[i]
      #colorData[i] = (255 << 24) | (value << 16) | (value << 8) | value
    #undefined

  #heat: (stretchData,colorData) ->
    #map = new Colormap()
    #i = stretchData.length
    #while i--
      #colorData[i] = map.getValue(stretchData[i])
  
  #heat: (r,g,b) ->
    #r.add(0,0)
    #r.add(0.34,1)
    #r.add(1,1)
    #g.add(0,0)
    #g.add(1,1)
    #b.add(0,0)
    #b.add(0.65,0)
    #b.add(0.98,1)
    #b.add(1,1)
    #
  gray: ->
    map = {
      type: 'SAO'
      red:
        level: [0,1]
        intensity: [0,1]
      green:
        level: [0,1]
        intensity: [0,1]
      blue:
        level: [0,1]
        intensity: [0,1] }
  
  heat: {
    type: 'SAO'
    red:
      level: [0,0.34,1]
      intensity: [0,1,1]
    green:
      level: [0,1]
      intensity: [0,1]
    blue:
      level: [0,0.65,0.98,1]
      intensity: [0,0,1,1] }

module?.exports = colors
