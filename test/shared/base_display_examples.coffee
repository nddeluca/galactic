examplesForBaseDisplayInterface = (baseDisplayObject, canvasObject) ->

  describe 'base display interface', ->
    baseDisplay = null
    canvas = null

    beforeEach ->
      canvas = new canvasObject()

    describe 'when provided dimensions', ->
      width = null
      height = null

      beforeEach ->
        width = 100
        height = 100

        baseDisplay = new baseDisplayObject(canvas: canvas, height: height, width: width)

      it 'should have the width set through construction', ->
        expect(baseDisplay.width).toEqual width

      it 'should have the height set through contruction', ->
        expect(baseDisplay.height).toEqual height


    describe 'when not provided dimensions', ->

      beforeEach ->
        args = {canvas: canvas}
        spyOn(baseDisplayObject.prototype,'calculate_width').andCallThrough()
        spyOn(baseDisplayObject.prototype,'calculate_height').andCallThrough()
        baseDisplay = new baseDisplayObject(args)


      it 'should call calculate_width if no width is provided', ->
        expect(baseDisplayObject.prototype.calculate_width).toHaveBeenCalled()

      it 'should call calculate_height if no height is provided', ->
        expect(baseDisplayObject.prototype.calculate_height).toHaveBeenCalled()


    describe 'post initialize hook', ->
      args = null

      beforeEach ->
        args = {canvas: canvas}
        spyOn(baseDisplayObject.prototype,'post_initialize')
        baseDisplay = new baseDisplayObject(args)

      it 'should be called after construction', ->
        expect(baseDisplayObject.prototype.post_initialize).toHaveBeenCalled()

      it 'should be called with the same arguments passed to the constructor', ->
        expect(baseDisplayObject.prototype.post_initialize).toHaveBeenCalledWith(args)


    describe 'canvas used for display', ->

      beforeEach ->
        args = {canvas: canvas, height: 123, width: 123}
        baseDisplay = new baseDisplayObject(args)

      it 'should have the same width as the display', ->
        expect(baseDisplay.canvas.width).toEqual baseDisplay.width

      it 'should have the same height as the display', ->
        expect(baseDisplay.canvas.height).toEqual baseDisplay.height


    describe "draw", ->

      beforeEach ->
        baseDisplay = new baseDisplayObject(canvas: canvas, width: 4, height: 4)

        #Workaround for no html5 canvas while testing in node
        baseDisplay.canvasData.data.set = (data) -> return null

        spyOn(baseDisplay.canvasData.data,'set')
        spyOn(baseDisplay.context,'putImageData')

        baseDisplay.draw()

      it 'should set the canvasView8 to the canvasData', ->
        expect(baseDisplay.canvasData.data.set).toHaveBeenCalledWith(baseDisplay.canvasView8)

      it 'should call putImageData on the canvas context', ->
        expect(baseDisplay.context.putImageData).toHaveBeenCalledWith(baseDisplay.canvasData,0,0)

module?.exports = examplesForBaseDisplayInterface
