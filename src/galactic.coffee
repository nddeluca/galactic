#Galactic is a library for displaying fits images of galaxies
#and creating light intensity models interactively.

Galactic = {}
Galactic.VERSION = '0.0.1'

Galactic.Image = require('./image')

Galactic.Display = require('./display')
Galactic.ImageFormatter = require('./image_formatter')

Galactic.stretches = require('./stretches')
Galactic.colors = require('./colors')

Galactic.Model = require('./model')
Galactic.Modeler = require('./modeler')
Galactic.Sersic = require('./sersic')
Galactic.Residual = require('./residual')

Galactic.PSFConvoluter = require('./psf_convoluter')

Galactic.utils = {}
Galactic.utils.arrayutils = require ('./utils/arrayutils')
Galactic.utils.bitswap = require ('./utils/bitswap')
Galactic.utils.bitreverse = require('./utils/bitreverse')

Galactic.Gradient = require('./gradient')
Galactic.Colormap = require('./colormap')


module?.exports = Galactic
