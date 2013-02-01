Galactic = {}

Galactic.VERSION = '0.0.1'


#display related classes
Galactic.Display = require('./display')
Galactic.Canvas = require('./canvas')
Galactic.StretchProcessor = require('./stretch_processor')
Galactic.ColorProcessor = require('./color_processor')

#model related classes
Galactic.Model = require('./model')
Galactic.Residual = require('./residual')

#dipslay related functions and utilities
Galactic.utils = require ('./utils')
Galactic.stretches = require('./stretches')
Galactic.colors = require('./colors')

#model related functions and utilites
Galactic.models = require('./models')


module?.exports = Galactic
