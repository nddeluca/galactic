Residual = require('./residual')
Model = require('./model')
Sersic = require('./sersic')
Image = require('./image')
utils = require('./utils')

class Modeler
  constructor: (@fitsImage) ->

    @fitsData = @fitsImage.data
    @width = @fitsImage.width
    @height = @fitsImage.height

    @image = new Image(@width,@height)

    #initialize model array
    @models = []


  #Functions to interact with the models array
  addModel: (name,type) ->
    switch type
      when 'sersic'
        model = new Sersic(name,@width,@height)
      else
        return false

    @models.push(model)
    #return the newly created model
    model

  removeModel: (name) ->
    model = @findModel(name)
    index = @models.indexOf(model)
    @models.splice(index,1)

  findModel: (name) ->
    for model in @models
      if model.name == name
        return model
    false

  updateParams: (name,params) ->
    model = @findModel(name)
    model.params = params
    undefined

  rebuildModel: (name) ->
    model = @findModel
    model.generate
    undefined
  
  disableModel: (name) ->
    model = @findModel(name)
    model.status = "Disabled"
    undefined

  enableModel: (name) ->
    model = @findModel(name)
    model.status = "Active"
    undefined

  findModel: (name) ->
    for model in @models
      if model.name == name
        return model
    false

  getActiveModels: ->
    models = []
    for model in @models
      if model.isActive
        models.push(model)
    models
 
  generate: ->
    models = @getActiveModels
    
    #get first array element to set data
    model = models.shift
    model.generate
    for index in [0..@width*@height]
      @image.data[index] = model.data[index]

    #add other models
    if models.length > 0
      for model in models
        model.generate
        for index in [0..@width*@height]
          @image.data[index] += model.data[index]

    undefined

module?.exports = Modeler
