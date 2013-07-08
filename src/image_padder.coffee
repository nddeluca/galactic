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

    l = paddedData.length
    while l--
      paddedData[l] = 0

    delta_h = Math.ceil((paddedHeight - height) / 2)
    delta_w = Math.ceil((paddedWidth - width) / 2)

    y = height
    while y--
      offset1 = y*width
      offset2 = (y + delta_h)*paddedWidth + delta_w
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

    delta_h = Math.ceil((paddedHeight - height) / 2)
    delta_w = Math.ceil((paddedWidth - width) / 2)

    y = height
    while y--
      offset1 = y*width
      offset2 = (y + delta_h)*paddedWidth + delta_w
      x = width
      while x--
        data[x + offset1] = paddedData[x + offset2]

    undefined

module?.exports = ImagePadder
