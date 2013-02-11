Model = require('./model')

class Sersic extends Model
  constructor: (@name,@width,@height) ->
    super(@name,@width,@height)
    @initDefaultParams
    @initParamArray

  initParamArray: ->
    @paramArray = ['centerX',
     'centerY',
     'angle',
     'axisRatio',
     'effRadius',
     'intensity',
     'n']

  initDefaultParams: ->
    @params =
      centerX: 31.5
      centerY: 42
      angle: 0
      axisRatio: 1
      effRadius: 6
      intensity: 2.3
      n: 1
    
  build: ->
    super
    norm = @params.n*Math.exp(0.6950-0.1789/@params.n)
    sin = Math.sin(@params.angle)
    cos = Math.cos(@params.angle)
    for x in [0..(@width-1)]
      for y in [(@height-1)..0]
        r_x = (x-@params.center.x)*cos+(y-@params.center.y)*sin
        r_y = ((y-@params.center.y)*cos-(x-@params.center.x)*sin)/@params.axisRatio
        r = Math.sqrt(r_x*r_x + r_y*r_y)
        exponent = norm*Math.pow(r/@params.effRadius,1/@params.n) - 1
        @data[y*width+x] = @params.intensity*Math.exp(-exponent)
    undefined
