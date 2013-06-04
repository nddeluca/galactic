examplesForImageInterface = (imageObject) ->

  describe 'Image Interface', ->
    image = null

    beforeEach ->
      image = new imageObject()

    it 'should have a default height of 512', ->
      expect(image.default_height()).toEqual 512

    it 'should have a default width of 512', ->
      expect(image.default_width()).toEqual 512

    it 'should have a default data type of float 64', ->
      expect(image.default_data_type()).toEqual Float64Array

    describe 'Post initilize hook', ->
      args = null

      beforeEach ->
        args = width: 10, height: 10, extraArg: "extra"
        spyOn(image, 'post_initialize')
        image.constructor(args)

      it 'should be called on construction', ->
        expect(image.post_initialize).toHaveBeenCalled()

      it 'should be called with the correct arguments', ->
        expect(image.post_initialize).toHaveBeenCalledWith(args)


    describe 'width', ->

      it 'should be set to the default when it is not provided', ->
        expect(image.width).toEqual image.default_width()

      it 'should be set to the correct value when provided', ->
        image = new imageObject(width: 123)
        expect(image.width).toEqual 123

    describe 'height', ->

      it 'should be set to the default when it is not provided', ->
        expect(image.height).toEqual image.default_height()

      it 'should be set to the correct value when provided', ->
        image = new imageObject(height: 321)
        expect(image.height).toEqual 321

    describe 'data', ->

      it 'should set the data type to the default when it is not provided', ->
        expect(image.data).toEqual jasmine.any(Float64Array)

      it 'should set the data type to the provided type', ->
        image = new imageObject(dataType: Float32Array)
        expect(image.data).toEqual jasmine.any(Float32Array)

      it 'should have the correct length', ->
        expect(image.data.length).toEqual image.width*image.height

module?.exports = examplesForImageInterface
