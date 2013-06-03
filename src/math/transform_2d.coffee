RowManipulator = require('../row_manipulator')
ColumnManipulator = require('../column_manipulator')
revbin_permute = require('../utils/arrayutils').revbin_permute

class Transform2d

  constructor: (args = {}) ->
    @rImage = args.realImage
    @iImage = args.imaginaryImage

    @method = args.method || @default_method()

    @permutator = args.permutator || @default_permutator()
    @permute = args.permute || @default_permute()

    rowManipulator = args.rowManipulator || @default_row_manipulator()
    columnManipulator = args.columnManipulator || @default_column_manipulator()

    @rowm = new rowManipulator(@rImage)
    @colm = new columnManipulator(@rImage)
    @irowm = new rowManipulator(@iImage)
    @icolm = new columnManipulator(@iImage)

    default_row_manipulator: ->
      RowManipulator

    default_column_manipulator: ->
      ColumnManipulator

    default_method: ->
      "dif"

    default_permutator: ->
      revbin_permute

    default_permute: ->
      true
      `









module?.exports = Transform2d
