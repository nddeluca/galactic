Image = require('./image')

class Residual extends Image

  post_initialize: (args) ->
    @fitsData = args.fitsData
    @modelData = args.modelData

  build: ->
    residual = @data
    fits = @fitsData
    model = @modelData
    i = @width*@height

    while i--
      residual[i] = fits[i] - model[i]

    undefined

module?.exports = Residual
