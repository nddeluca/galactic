examplesForImageInterface = require('../shared/image_examples')
examplesForModelInterface = require('../shared/model_examples')

Model = require('../../src/model')

describe 'Model', ->
  examplesForImageInterface(Model)
  examplesForModelInterface(Model)
