require('../spec_helper')

Image = require('../../src/image')

describe 'Image', ->
  image = null

  beforeEach ->
    image = new Image()


  describe 'width', ->

    it 'should be set to the default when it is not provided', ->
      image = new Image()
      expect(image.width).toEqual image.default_width()

    it 'should be set to the correct value when provided', ->
      image = new Image({width: 123})
      expect(image.width).toEqual 123

  describe 'height', ->

    it 'should be set to the default when it is not provided', ->
      image = new Image()
      expect(image.height).toEqual image.default_height()

    it 'should be set to the correct value when provided', ->
      image = new Image({height: 321})
      expect(image.height).toEqual 321



    describe 'buffer', ->

      it 'should be an ArrayBuffer', ->
        expect(image.buffer).toBeType('ArrayBuffer')

    describe 'data', ->

      it 'should have the correct buffer', ->
        expect(image.data.buffer).toEqual image.buffer

      it 'should have the correct length', ->
        expect(image.data.length).toBe image.width*image.height

