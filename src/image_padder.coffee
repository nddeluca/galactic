closest_power_of_two = require('./utils/closest_power_of_two')

class ImagePadder

  constructor: (args = {}) ->
    @image = args.image
    @paddedClass = args.type
    @maxWidth = args.maxWidth || @default_max_width()
    @maxHeight = args.maxHeight || @default_max_height()
    paddedWidth = closest_power_of_two(@image.width,@maxWidth)
    paddedHeight = closest_power_of_two(@image.height,@maxHeight)

    @paddedImage = new @paddedClass({width: paddedWidth, height: paddedHeight, dataType: @image.dataType })
    @load()

  default_max_width: ->
    512

  default_max_height: ->
    512

  load: ->
    data = @image.data
    width = @image.width
    height = @image.height
    paddedData = @paddedImage.data
    paddedWidth = @paddedImage.width
    paddedHeight = @paddedImage.height

    y = paddedHeight - 1
    while y >= height
      offset = y*paddedWidth
      x = paddedWidth - 1
      while x >= width
        paddedData[x + offset] = 0
        x--
      y--

    y = height
    while y--
      offset1 = y*width
      offset2 = y*paddedWidth
      x = width
      while x--
        paddedData[x + offset2] = data[x + offset1]

  save: ->
    data = @image.data
    width = @image.width
    height = @image.height
    paddedData = @paddedImage.data
    paddedWidth = @paddedImage.width
    paddedHeight = @paddedImage.height

    y = height
    while y--
      offset1 = y*width
      offset2 = y*paddedWidth
      x = width
      while x--
        data[x + offset1] = paddedData[x + offset2]

    undefined

module?.exports = ImagePadder
