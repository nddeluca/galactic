Residual = require('./residual')
Model = require('./model')
Sersic = require('./sersic')
Image = require('./image')
utils = require('./utils/arrayutils')

class Modeler

  constructor: (@fitsImage) ->
    @fitsData = @fitsImage.data
    @width = @fitsImage.width
    @height = @fitsImage.height
    @image = new Image({width: @width, height: @height})
    @residual = new Residual(fitsData: @fitsData, modelData: @image.data, width: @width, height: @height)
    @models = []
    @undo = []


  #Create a new model and add it to the model array.
  #The name attribute should be unique
  add: (name,type) ->
    switch type
      when 'sersic'
        model = new Sersic(name: name, width: @width, height: @height)
      else
        return false

    @models.push(model)
    #return the newly created model
    model

  #Remove a model from the array
  remove: (name) ->
    model = @find(name)
    index = @models.indexOf(model)
    @models.splice(index,1)

  #Find a model by name
  find: (name) ->
    for model in @models
      if model.name == name
        return model
    false

  #Pass a model name along with updated params
  updateParams: (name,params) ->
    model = @find(name)
    model.updateParams(params)
    undefined

  updateParam: (name,param,value) ->
    model = @find(name)
    model.params[param] = value
    model.stale = true

  disable: (name) ->
    model = @find(name)
    model.disable()
    undefined

  enable: (name) ->
    model = @find(name)
    model.enable()
    undefined

  #Creates an array of all enabled models
  getEnabledModels: ->
    models = []
    for model in @models
      if model.enabled
        models.push(model)
    models
  
  @saveUndo: ->
    @undo.push(@models)
    if @undo.length > 10
      @undo.pop

  @reloadUndo: ->
    if @undo.length > 0
      @models = @undo[0]
      @undo.splice(0,1)

  toJSON: ->
    JSON.stringify(@models)
    
  build: ->
    length = @width*@height
    models = @getEnabledModels()
    imageData = @image.data

    if models.length == 0
      i = length
      while i--
        imageData[i] = 0
    else
      model = models.shift()
      model.build() if model.stale
      modelData = model.data
      i = length
      while i--
        imageData[i] = modelData[i]

      if models.length > 0
        for model in models
          model.build() if model.stale
          modelData = model.data
          i = length
          while i--
            imageData[i] += modelData[i]

    @residual.build()

    undefined

module?.exports = Modeler
