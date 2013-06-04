examplesForImageInterface = require('../shared/image_examples')
examplesForModelInterface = require('../shared/model_examples')

Sersic = require('../../src/sersic')

describe 'Model', ->
  examplesForImageInterface(Sersic)
  examplesForModelInterface(Sersic)

