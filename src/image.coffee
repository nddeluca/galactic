class Image

  constructor: (args = {}) ->
    @width = args.width || @default_width()
    @height = args.height || @default_height()
    @dataType = args.dataType || @default_data_type()

    @buffer = new ArrayBuffer(@width*@height*@dataType.BYTES_PER_ELEMENT)
    @data = new @dataType(@buffer)

    @post_initialize(args)

  post_initialize: (args) ->
    null

  default_data_type: ->
    Float64Array

  default_width: ->
    512

  default_height: ->
    512

module?.exports = Image
