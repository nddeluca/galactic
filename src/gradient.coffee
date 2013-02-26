
class Gradient
  
  constructor: ->
    @range = 256
    @buffer = new ArrayBuffer(@range*4)
    @gradient = new Uint32Array(@buffer)
    @colors = []
    @type = 'linear'

  addColor: (red,blue,green,position) ->
    color = {
      r: red
      b: blue
      g: green
      pos: position }
    @colors.push(color)

  generate: ->
    colors = @colors
    i = colors.length-1
    while i--
      color2 = colors[i+1]
      color1 = colors[i]
      pos1 = color1.pos
      pos2 = color2.pos
      range = pos2-pos1

      for j in [range..0]
        r = ~~((color2.r - color1.r)*(j/range))
        b = ~~((color2.b - color1.b)*(j/range))
        g = ~~((color2.g - color2.g)*(j/range))
        @gradient[pos1 + j] = @getPixel(r,b,g)



  getPixel: (r,b,g) ->
    (255 << 24) | (r << 16) | (b << 8) | g


module?.exports = Gradient
