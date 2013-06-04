class RowManipulator

  constructor: (args = {}) ->
    @image = args.image
    @buffer = new ArrayBuffer(@image.dataType.BYTES_PER_ELEMENT*@image.width)
    @row = new @image.dataType(@buffer)

  load: (r) ->
    row = @row
    data = @image.data
    imageWidth = @image.width

    offset = r*imageWidth
    x = imageWidth
    while x--
      row[x] = data[x + offset]

    undefined

  save: (r) ->
    row = @row
    data = @image.data
    imageWidth = @image.width

    offset = r*imageWidth
    x = imageWidth
    while x--
      data[x + offset] = row[x]

    undefined



module?.exports = RowManipulator
