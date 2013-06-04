ColumnManipulator = require('../../src/column_manipulator')

describe 'ColumnManipulator', ->
  image = null
  manipulator = null
  result = null

  beforeEach ->
    width = 64
    height = 64
    buffer = new ArrayBuffer(Float64Array.BYTES_PER_ELEMENT*width*height)
    data = new Float64Array(buffer)

    for x in [0..width-1]
      for y in [0..height-1]
        data[x + y*width] = 2

    for y in [0..height-1]
      data[0 + y*width] = 1

    for y in [0..width-1]
      data[(height-1)+ y*width] = 3

    image = {width: width, height: height, dataType: Float64Array, data: data}
    manipulator = new ColumnManipulator(image: image)

    resultbuff = new ArrayBuffer(Float64Array.BYTES_PER_ELEMENT*image.height)
    result = new Float64Array(resultbuff)

  it "should return the first column correctly", ->
    manipulator.load(0)

    for y in [0..image.height-1]
      result[y] = 1

    expect(manipulator.column).toEqual result

  it "should return the last image column correctly", ->
    manipulator.load(image.width-1)

    for y in [0..image.height-1]
      result[y] = 3

    expect(manipulator.column).toEqual result


  it "should return a middle column correctly", ->
    manipulator.load(~~((image.width-1)/2))

    for y in [0..image.height-1]
      result[y] = 2

    expect(manipulator.column).toEqual result


  it "should save the first column correctly", ->
    for y in [0..image.height-1]
      manipulator.column[y] = 5

    manipulator.save(0)

    for y in [0..image.height-1]
      result[y] = image.data[y*image.width]

    expect(manipulator.column).toEqual result

  it "should save the last column correclty", ->
    for y in [0..image.height-1]
      manipulator.column[y] = 5

    manipulator.save(image.width-1)

    for y in [0..image.height-1]
      result[y] = image.data[(image.height-1) + y*image.width]

    expect(manipulator.column).toEqual result

  it "should save a middle column correctly", ->

    for y in [0..image.height-1]
      manipulator.column[y] = 5

    manipulator.save(~~((image.height-1)/2))

    for y in [0..image.width-1]
      result[y] = image.data[~~((image.height-1)/2) + y*image.width]

    expect(manipulator.column).toEqual result

