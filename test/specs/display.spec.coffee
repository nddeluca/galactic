Display = require('../../src/display')
Canvas = require('canvas')

describe 'Display', ->
  display = null
  canvas = null

  beforeEach ->
    canvas = new Canvas()
    display = new Display(canvas: canvas)

  describe 'when provided dimensions', ->
    width = null
    height = null

    beforeEach ->
      width = 100
      height = 100

      display = new Display(canvas: canvas, height: height, width: width)

    it 'should have the width set through construction', ->
      expect(display.width).toEqual width

    it 'should have the height set through contruction', ->
      expect(display.height).toEqual height


  describe 'when not provided dimensions', ->

    beforeEach ->
      spyOn(Display.prototype,'calculate_width').andCallThrough()
      spyOn(Display.prototype,'calculate_height').andCallThrough()
      display = new Display(canvas: canvas)


    it 'should call calculate_width if no width is provided', ->
      expect(Display.prototype.calculate_width).toHaveBeenCalled()

    it 'should call calculate_height if no height is provided', ->
      expect(Display.prototype.calculate_height).toHaveBeenCalled()

  describe 'canvas used for display', ->

    beforeEach ->
      display = new Display(canvas: canvas, height: 123, width: 123)

    it 'should have the same width as the display', ->
      expect(display.canvas.width).toEqual display.width

    it 'should have the same height as the display', ->
      expect(display.canvas.height).toEqual display.height


  describe "draw", ->

    beforeEach ->
      display = new Display(canvas: canvas, width: 4, height: 4)

      #Workaround for no html5 canvas while testing in node
      display.canvasData.data.set = (data) -> return null

      spyOn(display.canvasData.data,'set')
      spyOn(display.context,'putImageData')

      display.draw({ data: [], width: 0, height: 0})

    it 'should set the canvasView8 to the canvasData', ->
      expect(display.canvasData.data.set).toHaveBeenCalledWith(display.canvasView8)

    it 'should call putImageData on the canvas context', ->
      expect(display.context.putImageData).toHaveBeenCalledWith(display.canvasData,0,0)

