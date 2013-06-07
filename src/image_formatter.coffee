stretches = require('./stretches')
colors = require('./colors')
utils = require('./utils/arrayutils')
Image = require('./image')
Colormap = require('./colormap')

class ImageFormatter

  constructor: (args) ->
    @input = args.input || throw "No input provided"
    @output = args.output || new Image(width: @input.width, height: @input.height, dataType: Uint32Array)
    @stretch = args.strech || stretches.linear
    @colors = args.colors || colors
    @colormap = args.colormap || new Colormap(@colors.gray)
    @stretches = args.stretches || stretches
    @min = utils.min(input.data)
    @max = utils.max(input.data)

  setStretch: (stretch) ->
    switch stretch
      when "linear"
        @stretch = @stretches.linear
        true
      when "log"
        @stretch = @stretches.log
        true
      when "power"
        @stretch = @stretches.power
        true
      when "sqrt"
        @stretch = @stretches.sqrt
        true
      when "arcsinh"
        @stretch = @stretches.arcsinh
        true
      else false

  setColormap: (map) ->
    switch map
      when "gray"
        @colormap.setMap(@colors.gray)
        true
      when "red"
        @colormap.setMap(@colors.red)
        true
      when "green"
        @colormap.setMap(@colors.green)
        true
      when "blue"
        @colormap.setMap(@colors.blue)
        true
      when "heat"
        @colormap.setMap(@colors.heat)
        true
      when "a"
        @colormap.setMap(@colors.a)
        true
      when "b"
        @colormap.setMap(@colors.b)
        true
      when "bb"
        @colormap.setMap(@colors.bb)
        true
      when "cool"
        @colormap.setMap(@colors.cool)
        true
      when "he"
        @colormap.setMap(@colors.he)
        true
      when "rainbow"
        @colormap.setMap(@colors.rainbow)
        true
      when "standard"
        @colormap.setMap(@colors.standard)
        true
      else false

  convert: ->
    @stretch(@input.data,@output.data,@colormap.pixelMap,@min,@max)
    return @output


module?.exports = ImageFormatter
