ImageDisplay = require('../../src/image_display')
Canvas = require('canvas')

examplesForBaseDisplayInterface = require('../shared/base_display_examples')

describe 'Display', ->
  examplesForBaseDisplayInterface(ImageDisplay,Canvas)


