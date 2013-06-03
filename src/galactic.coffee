#Galactic is a library for displaying fits images of galaxies
#and creating light intensity models interactively.

Galactic = {}
Galactic.VERSION = '0.0.1'

#Base classes
Galactic.Image = require('./image')
Galactic.Canvas = require('./canvas')

#Class that handles the displaying of fits image data, model data,
#and residual data.
Galactic.Display = require('./display')

#Files contained functions used by the display
Galactic.stretches = require('./stretches')
Galactic.colors = require('./colors')

#Classes used to handle the creation and manipulation of
#galaxy models.
Galactic.Model = require('./model')
Galactic.Modeler = require('./modeler')
Galactic.Sersic = require('./sersic')
Galactic.Residual = require('./residual')

#Common functions that don't belong to a class.
Galactic.utils = {}
Galactic.utils.arrayutils = require ('./utils/arrayutils')
Galactic.utils.bitswap = require ('./utils/bitswap')
Galactic.utils.bitreverse = require('./utils/bitreverse')

Galactic.Gradient = require('./gradient')
Galactic.Colormap = require('./colormap')


module?.exports = Galactic
