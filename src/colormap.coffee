Gradient = require('./gradient')

class Colormap
  constructor: ->
    @initGradients()
    @initValues()

  initGradients: ->
    @red = new Gradient()
    @green = new Gradient()
    @blue = new Gradient()

  initValues: ->
    r = @red
    g = @green
    b = @blue

    r.add(0,0)
    r.add(0.34,1)
    r.add(1,1)
    g.add(0,0)
    g.add(1,1)
    b.add(0,0)
    b.add(0.65,0)
    b.add(0.98,1)
    b.add(1,1)

    r.build()
    g.build()
    b.build()


  getValue: (level) ->
    r = @red.gradient[level]
    g = @green.gradient[level]
    b = @blue.gradient[level]
    (255 << 24) | (r << 16) | (g << 8) | b
  

module?.exports = Colormap
