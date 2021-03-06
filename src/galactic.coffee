#Galactic is a library for displaying fits images of galaxies
#and creating light intensity models interactively.

Galactic = {}
Galactic.VERSION = '0.0.1'

Galactic.Image = require('./image')

Galactic.Display = require('./display')
Galactic.ImageFormatter = require('./image_formatter')

Galactic.ImagePadder = require('./image_padder')
Galactic.RowManipulator = require('./row_manipulator')
Galactic.ColumnManipulator = require('./column_manipulator')

Galactic.stretches = require('./stretches')
Galactic.colors = require('./colors')

Galactic.Model = require('./model')
Galactic.Modeler = require('./modeler')
Galactic.Sersic = require('./sersic')
Galactic.Residual = require('./residual')

Galactic.PSFConvolutor = require('./psf_convolutor')

Galactic.utils = {}
Galactic.utils.arrayutils = require ('./utils/arrayutils')
Galactic.utils.bitswap = require ('./utils/bitswap')
Galactic.utils.bitreverse = require('./utils/bitreverse')

Galactic.Gradient = require('./gradient')
Galactic.Colormap = require('./colormap')

Galactic.math = {}
Galactic.math.fftdif4 = require('./math/fftdif4')
Galactic.math.fftdit4 = require('./math/fftdit4')

module?.exports = Galactic
