examplesForImageInterface= require('../shared/image_examples')
Residual = require('../../src/residual')

describe 'Residual', ->
  examplesForImageInterface(Residual)

  residual = null
  fitsData = null
  modelData = null
  difference = null

  beforeEach ->
    fitsData = [6,5,4]
    modelData = [1,2,3]

    residual = new Residual(width: 3, height: 1, fitsData: fitsData, modelData: modelData)

    buffer = new ArrayBuffer(residual.dataType.BYTES_PER_ELEMENT*3)
    difference = new residual.dataType(buffer)

    difference[0] = 5
    difference[1] = 3
    difference[2] = 1

  it 'should set the fitsData on construction', ->
    expect(residual.fitsData).toEqual fitsData

  it 'should set the modelData on construction', ->
    expect(residual.modelData).toEqual modelData

  describe 'residual data', ->
    it 'should be equal to the difference of the fitsData and modelData', ->
      residual.build()
      expect(residual.data).toEqual difference


