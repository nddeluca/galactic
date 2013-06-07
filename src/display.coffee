class Display

  constructor: (args = {}) ->
    @canvas = args.canvas || @_set_up_canvas_from_container(args.container)
    @width = args.width || @calculate_width(args)
    @height = args.height || @calculate_height(args)

    @canvas.width = @width
    @canvas.height = @height
    @context = @canvas.getContext('2d')

    #@canvasData = @context.createImageData(@width,@height)
    #
    @canvasBuffer = new ArrayBuffer(@width*@height*Uint32Array.BYTES_PER_ELEMENT)
    @canvasView8 = new Uint8ClampedArray(@canvasBuffer)
    @canvasView32 = new Uint32Array(@canvasBuffer)

  calculate_width: (args) ->
    #args.image.width
    512

  calculate_height: (args) ->
    #Math.round((args.image.height/args.image.width)*@width)
    512

  draw: (image) ->
    imageData = image.data
    imageWidth = image.width
    imageHeight = image.height

    canvasData = @canvasView32
    canvasWidth = @width
    canvasHeight = @height

    xScaleRatio = imageWidth/canvasWidth
    yScaleRatio = imageHeight/canvasHeight
    invertCoeff = (imageHeight - 1)*imageWidth

    x = canvasWidth
    while x--
      coeff = ~~(x*xScaleRatio) + invertCoeff
      y = canvasHeight
      while y--
        canvasData[(canvasWidth*y)+x] = imageData[coeff - (~~(y*yScaleRatio))*imageWidth]

    #cData = @canvasData
    #cData.data.set(@canvasView8)
    #@context.putImageData(cData,0,0)

    @context.putImageData(@canvasView8,0,0)
    undefined

  _set_up_canvas_from_container: (container) ->
    @container = document.getElementById(container)
    @canvas = document.createElement('canvas')
    @container.appendChild(@canvas)

module?.exports = Display
