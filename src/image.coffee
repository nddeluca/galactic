class Image

  constructor: (args = {}) ->
    @width = args.width || @default_width()
    @height = args.height || @default_height()
    @dataType = args.dataType || @default_data_type()
    @init_data_storage()
    @post_initialize(args)

  post_initialize: (args) ->
    null

  init_data_storage: ->
    @buffer = new ArrayBuffer(@width*@height*@dataType.BYTES_PER_ELEMENT)
    @data = new @dataType(@buffer)

  default_data_type: ->
    Float64Array

  default_width: ->
    512

  default_height: ->
    512

    #getRow: (r) ->
    #row = @row
    #data = @data
    #x = @width
    #while x--
    #row[x] = data[x + r*width]
    #row

    #getColumn: (c) ->
    #column = @column
    #data = @data
    #width = @width
    #y = @height
    #while y--
    #column[y] = data[c + y*width]

module?.exports = Image
