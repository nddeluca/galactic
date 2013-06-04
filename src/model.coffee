Image = require('./image')

class Model extends Image

  post_initialize: (args) ->
    @name = args.name
    @enabled = unless args.enabled? then true else args.enabled
    @stale = unless args.stale? then true else args.stale
    @set_up_parameters(args)

  set_up_parameters: (args) ->
    null

  enable: ->
    @enabled = true

  disable: ->
    @enabled = false

  update_params: (args) ->
    @stale = true
    @on_params_update(args)

  on_params_update: (args) ->
    null

  build: ->
    @stale = false
    @calculate()

  calculate: ->
    null


module?.exports = Model
