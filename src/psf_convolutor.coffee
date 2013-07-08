fft_dif4_core = require('./math/fftdif4')
fft_dit4_core = require('./math/fftdit4')
closest_power_of_two = require('./utils/closest_power_of_two')

RowManipulator = require('./row_manipulator')
ColumnManipulator = require('./column_manipulator')
ImagePadder = require('./image_padder')
Image = require('./image')

class PSFConvolutor

  constructor: (args = {}) ->
    @model = args.model
    @psf = args.psf

    min_width = @model.width + @psf.width - 1
    min_height = @model.height + @psf.height - 1

    paddedWidth = closest_power_of_two(min_width, 1024)
    paddedHeight = closest_power_of_two(min_height, 1024)

    @modelPadder = new ImagePadder(image: @model, type: Image, paddedWidth: paddedWidth, paddedHeight: paddedHeight)

    @psfPadder = new ImagePadder(image: @psf, type: Image, paddedWidth: paddedWidth, paddedHeight: paddedHeight)

    @rows = @modelPadder.paddedImage.height
    @columns = @modelPadder.paddedImage.width

    @iModelImage = new Image(width: @columns, height: @rows, dataType: @model.dataType)
    @iPsfImage = new Image(width: @columns, height: @rows, dataType: @psf.dataType)

    @rRowModel = new RowManipulator(image: @modelPadder.paddedImage)
    @iRowModel = new RowManipulator(image: @iModelImage)
    @rRowPsf = new RowManipulator(image: @psfPadder.paddedImage)
    @iRowPsf = new RowManipulator(image: @iPsfImage)

    @rColModel = new ColumnManipulator(image: @modelPadder.paddedImage)
    @iColModel = new ColumnManipulator(image: @iModelImage)
    @rColPsf = new ColumnManipulator(image: @psfPadder.paddedImage)
    @iColPsf = new ColumnManipulator(image: @iPsfImage)

    @paddedLength = @rows*@columns
    @ldnRow = Math.log(@rows)/Math.LN2
    @ldnColumn = Math.log(@columns)/Math.LN2

    @transform_psf()


  transform_psf: ->
    rows = @rows
    columns = @columns
    ldnRow = @ldnRow
    ldnCol = @ldnColumn

    padder = @psfPadder
    paddedLength = rows*columns

    imImage = @iPsfImage.data

    rRowM = @rRowPsf
    iRowM = @iRowPsf
    rColM = @rColPsf
    iColM = @iColPsf

    rRow = rRowM.row
    iRow = iRowM.row
    rCol = rColM.column
    iCol = iColM.column

    padder.load()

    l = paddedLength
    while l--
      imImage[l] = 0

    r = rows
    while r--
      rRowM.load(r)
      iRowM.load(r)
      fft_dif4_core(iRow,rRow,ldnRow)
      rRowM.save(r)
      iRowM.save(r)

    c = columns
    while c--
      rColM.load(c)
      iColM.load(c)
      fft_dif4_core(iCol,rCol,ldnCol)
      rColM.save(c)
      iColM.save(c)

    undefined


  convolute: ->
    rows = @rows
    columns = @columns
    ldnRow = @ldnRow
    ldnCol = @ldnColumn

    modelData = @model.data
    modelLength = @model.width*@model.height

    n = rows*columns
    norm = 1/(n*n)

    padder = @modelPadder
    paddedLength = rows*columns

    rPsfData = @psfPadder.paddedImage.data
    iPsfData = @iPsfImage.data

    rModelData = @modelPadder.paddedImage.data
    iModelData = @iModelImage.data

    rRowM = @rRowModel
    iRowM = @iRowModel
    rColM = @rColModel
    iColM = @iColModel

    rRow = rRowM.row
    iRow = iRowM.row
    rCol = rColM.column
    iCol = iColM.column

    padder.load()

    l = paddedLength
    while l--
      iModelData[l] = 0

    r = rows
    while r--
      rRowM.load(r)
      iRowM.load(r)
      fft_dif4_core(iRow,rRow,ldnRow)
      rRowM.save(r)
      iRowM.save(r)

    c = columns
    while c--
      rColM.load(c)
      iColM.load(c)
      fft_dif4_core(iCol,rCol,ldnCol)
      rColM.save(c)
      iColM.save(c)

    l = paddedLength
    while l--
      a = rModelData[l]
      b = iModelData[l]
      c = rPsfData[l]
      d = iPsfData[l]

      rModelData[l] = a*c - b*d
      iModelData[l] = a*d + b*c

    r = rows
    while r--
      rRowM.load(r)
      iRowM.load(r)
      fft_dit4_core(rRow,iRow,ldnRow)
      rRowM.save(r)
      iRowM.save(r)

    c = columns
    while c--
      rColM.load(c)
      iColM.load(c)
      fft_dit4_core(rCol,iCol,ldnCol)
      rColM.save(c)
      iColM.save(c)

    half_col = columns/2
    half_row = rows/2

    y = half_row
    while y--
      x = half_col
      while x--
        pos1 = x + y*columns
        pos3 = (x + half_col) + (y + half_row)*columns

        tmp13 = rModelData[pos1]
        rModelData[pos1] = rModelData[pos3]
        rModelData[pos3] = tmp13

        pos2 = x + half_col + y*columns
        pos4 = x + (y + half_row)*columns

        tmp24 = rModelData[pos2]
        rModelData[pos2] = rModelData[pos4]
        rModelData[pos4] = tmp24

    padder.save()

    l = modelLength
    while l--
      modelData[l] *= norm

    undefined

module?.exports = PSFConvolutor
