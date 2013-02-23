#The Display class handles the displaying of grayscale image data, where each
#pixel of the original image is stored as Float32 intensity value.
#Using a chosen stretch (linear by default), the maps the original 
#Float32 intensity values onto a 0-255 integer instensity space.
#Then a with a chosen colormap (grayscale by default), the 0-255
#integer intensity values are mapped into RBGA pixel values for display
#on an HTML5 canvas.

Canvas = require('./canvas')
stretches = require('./stretches')
colors = require('./colors')
utils = require('./utils')
Image = require('./image')

class Display extends Canvas
  constructor: (container,desiredWidth,image) ->
    @image = new Image(image.width,image.height)
    @image.data = image.data
    @min = utils.min(image.data)
    @max = utils.max(image.data)

    scaledWidth = ~~desiredWidth
    @scaleRatio = @image.width/scaledWidth
    scaledHeight = ~~(@image.height/@scaleRatio)
    
    @buildStretchBuffers()
    @buildColorBuffers()
    
    @stretch = stretches.linear
    @colormap = colors.grayscale

    super container,scaledWidth,scaledHeight

  setStretch: (stretch) ->
    switch stretch
      when "linear"
        @stretch = stretches.linear
        true
      when "log"
        @stretch = stretches.log
        true
      when "power"
        @stretch = stretches.power
        true
      when "sqrt"
        @stretch = stretches.sqrt
        true
      when "arcsinh"
        @stretch = stretches.arcsinh
        true
      else false

  #This holds fits data with an applied scale (linear, log, etc)
  #All values should be 0 to 255 only
  buildStretchBuffers: ->
    @stretchBuffer = new ArrayBuffer(@image.width*@image.height)
    @stretchView8 = new Uint8ClampedArray(@stretchBuffer)
    undefined

  #Holds RGBA Array
  buildColorBuffers: ->
    @colorBuffer = new ArrayBuffer(@image.width*@image.height*4)
    @colorView8 = new Uint8ClampedArray(@colorBuffer)
    @colorView32 = new Uint32Array(@colorBuffer)
    undefined
  
  processImage: ->
    @stretch(@image.data,@stretchView8,@min,@max)
    @colormap(@stretchView8,@colorView32)

    invertCoeff = (@image.height - 1)*@image.width

    for x in [0..(@canvasWidth-1)]
      coeff = ~~(x*@scaleRatio) + invertCoeff
      for y in [0..(@canvasHeight-1)]
        @canvasView32[(@canvasWidth*y)+x] = @colorView32[coeff - (~~(y*@scaleRatio))*@image.width]
    undefined
    
module?.exports = Display
