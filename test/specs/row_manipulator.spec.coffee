RowManipulator = require('../../src/row_manipulator')

describe 'RowManipulator', ->
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

    for x in [0..width-1]
      data[x] = 1

    for x in [0..width-1]
      data[x + (height-1)*width] = 3

    image = {width: width, height: height, dataType: Float64Array, data: data}
    manipulator = new RowManipulator(image: image)

    resultbuff = new ArrayBuffer(Float64Array.BYTES_PER_ELEMENT*image.width)
    result = new Float64Array(resultbuff)

  it "should return the first row correctly", ->
    manipulator.load(0)

    for x in [0..image.width-1]
      result[x] = 1

    expect(manipulator.row).toEqual result

  it "should return the last image row correctly", ->
    manipulator.load(image.height-1)

    for x in [0..image.width-1]
      result[x] = 3

    expect(manipulator.row).toEqual result


  it "should return a middle row correctly", ->
    manipulator.load(~~((image.height-1)/2))

    for x in [0..image.width-1]
      result[x] = 2

    expect(manipulator.row).toEqual result


  it "should save the first row correctly", ->
    for x in [0..image.width-1]
      manipulator.row[x] = 5

    manipulator.save(0)

    for x in [0..image.width-1]
      result[x] = image.data[x]

    expect(manipulator.row).toEqual result

  it "should save the last row correclty", ->
    for x in [0..image.width-1]
      manipulator.row[x] = 5

    manipulator.save(image.height-1)

    for x in [0..image.width-1]
      result[x] = image.data[x + (image.height-1)*image.width]

    expect(manipulator.row).toEqual result

  it "should save a middle row correctly", ->

    for x in [0..image.width-1]
      manipulator.row[x] = 5

    manipulator.save(~~((image.height-1)/2))

    for x in [0..image.width-1]
      result[x] = image.data[x + ~~((image.height-1)/2)*image.width]

    expect(manipulator.row).toEqual result

