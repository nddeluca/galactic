class ColumnManipulator

  constructor: (args) ->
    @image = args.image
    @buffer = new ArrayBuffer(@image.dataType.BYTES_PER_ELEMENT*@image.height)
    @column = new @image.dataType(@buffer)

  load: (c) ->
    column = @column
    data = @image.data
    imageWidth = @image.width

    y = @image.height
    while y--
      column[y] = data[c + y*imageWidth]

    undefined

  save: (c) ->
    column = @column
    data = @image.data
    imageWidth = @image.width

    y = @image.height
    while y--
      data[c + y*imageWidth] = column[y]

    undefined



module?.exports = ColumnManipulator
