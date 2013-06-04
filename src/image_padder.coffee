closest_power_of_two = require('./utils/closest_power_of_two')
Image = require('./image')

class ImagePadder

  constructor: (args = {}) ->
    @originalImage = args.image
    @paddedClass = args.type || @default_padded_class()

    @maxWidth = args.maxWidth || @default_max_width()
    @maxHeight = args.maxHeight || @default_max_height()

    paddedWidth = args.paddedWidth || closest_power_of_two(@originalImage.width,@maxWidth)
    paddedHeight = args.paddedHeight || closest_power_of_two(@originalImage.height,@maxHeight)

    @paddedImage = new @paddedClass({width: paddedWidth, height: paddedHeight, dataType: @originalImage.dataType })

  default_max_width: ->
    512

  default_max_height: ->
    512

  default_padded_class: ->
    Image

  load: ->
    data = @originalImage.data
    width = @originalImage.width
    height = @originalImage.height
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

    undefined

  save: ->
    data = @originalImage.data
    width = @originalImage.width
    height = @originalImage.height
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
