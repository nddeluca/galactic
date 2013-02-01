Image = require('./image')

class Model extends Image
  constructor: (@name,@width,@height) ->
    @status = 'Active'
    super(@width,@height)
  
  isActive: ->
    if @status == 'Active'
      true
    else
      false

module?.exports = Model
