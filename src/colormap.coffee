Gradient = require('./gradient')

class Colormap extends Gradient
  constructor: ->
    super
    @initColors()
    @generate()

  initGradient: ->
    add = @addColor
    add(0,0,0,0)
    add(255,127,0,63)
    add(255,255,0,127)
    add(255,255,255,255)


  getValue: (intensity) ->
    @gradient[intensity]

module?.exports = Colormap
