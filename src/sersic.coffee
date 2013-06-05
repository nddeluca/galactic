Model = require('./model')

class Sersic extends Model

  set_up_parameters: (args) ->
    @centerX = if args.centerX? then (args.centerX - 1) else (@width/2 - 1)
    @centerY = if args.centerY? then (args.centerY - 1) else (@height/2 - 1)
    @angle = if args.angle? then args.angle else 0
    @axisRatio = if args.axisRatio? then args.axisRatio else 1
    @effRadius = if args.effRadius? then args.effRadius else ((@centerX + @centerY)/4)
    @intensity = if args.intensity then args.intensity else 10
    @n = if args.n? then args.n else 4

  on_params_update: (args) ->
    if args.centerX? then @centerX = args.centerX
    if args.centerY? then @centerY = args.centerY
    if args.angle? then @angle = args.angle
    if args.axisRatio? then @axisRatio = args.axisRatio
    if args.effRadius? then @effRadius = args.effRadius
    if args.intensity? then @intensity = args.intensity
    if args.n? then @n = args.n

  calculate: ->
    data = @data
    n = @n
    invN = 1/n
    cx = @centerX
    cy = @centerY
    angle = @angle
    invAxisRatio = 1/@axisRatio
    invEffRadius = 1/@effRadius
    intensity = @intensity

    if n == 4
      norm = 7.669
    else
      norm = n*Math.exp(0.6950-0.1789*invN)

    sin = Math.sin(angle)
    cos = Math.cos(angle)
    sin_ratio = sin*invAxisRatio
    cos_ratio = cos*invAxisRatio

    width = @width
    height = @height

    y = height
    while y--
      offset = y*width
      ydiff = y - cy
      x = width
      while x--
        xdiff = x - cx
        r_x = xdiff*cos + ydiff*sin
        r_y = ydiff*cos_ratio - xdiff*sin_ratio
        r = Math.sqrt(r_x*r_x + r_y*r_y)
        exponent = norm*(1 - Math.pow(r*invEffRadius,invN))
        data[offset+x] = intensity*Math.exp(exponent)

    undefined

module?.exports = Sersic
