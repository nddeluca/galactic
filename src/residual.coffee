Image = require('./image')

class Residual extends Image
  constructor: (@width,@height) ->
    super(@width,@height)

module?.exports = Residual
