fft_dif4_core = require('./math/fftdif4')
fft_dit4_core = require('./math/fftdit4')

RowManipulator = require('./row_manipulator')
ColumnManipulator = require('./column_manipulator')
ImagePadder = require('./image_padder')
Image = require('./image')

class PSFConvolutor

  constructor: (args = {}) ->
    @model = args.model
    @psf = args.psf

    @modelPadder = new ImagePadder({image: @model, type: Image})
    @psfPadder = new ImagePadder({image: @psf, type: Image})

    @rows = @modelPadder.paddedHeight
    @columns = @modelPadder.paddedWidth

    @iModelImage = new Image({width: @columns, height: @rows, dataType: @model.dataType})
    @iPsfImage = new Image({width: @columns, height: @rows, dataType: @psf.dataType})

    @rRowModel = new RowManipulator(@modelPadder.paddedImage)
    @iRowModel = new RowManipulator(@iModelImage)
    @rRowPsf = new RowManipulator(@psfPadder.paddedImage)
    @iRowPsf = new RowManipulator(@iPsfImage)

    @rColModel = new ColumnManipulator(@modelPadder.paddedImage)
    @iColModel = new ColumnManipulator(@iModelImage)
    @rColPsf = new ColumnManipulator(@psfPadder.paddedImage)
    @iColPsf = new ColumnManipulator(@iPsfImage)

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
      fft_dif4_core(rRow,iRow,ldnRow)
      rRowM.save(r)
      iRowM.save(r)

    c = columns
    while c--
      rColM.load(c)
      iColM.load(c)
      fft_dif4_core(rCol,iCol,ldnCol)
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
    norm = 1/(rows*columns)
    
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
      fft_dif4_core(rRow,iRow,ldnRow)
      rRowM.save(r)
      iRowM.save(r)

    c = columns
    while c--
      rColM.load(c)
      iColM.load(c)
      fft_dif4_core(rCol,iCol,ldnCol)
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
      fft_dit4_core(iRow,rRow,ldnRow)
      rRowM.save(r)
      iRowM.save(r)

    c = columns
    while c--
      rColM.load(c)
      iColM.load(c)
      fft_dit4_core(iCol,rCol,ldnCol)
      rColM.save(c)
      iColM.save(c)

    padder.save()

    l = modelLength
    while l--
      modelData[l] *= norm

    undefined





module?.exports = PSFConvolutor
