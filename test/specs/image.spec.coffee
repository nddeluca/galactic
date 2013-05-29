require('../spec_helper')

Image = require('../../src/image')

describe 'Image', ->
  image = null
  width = 100
  height = 100

  beforeEach ->
    image = new Image()

  describe 'instance variables', ->

    it 'should have a width', ->
      expect(image.width).toBeDefined()

    it 'should have a height', ->
      expect(image.height).toBeDefined()

    it 'should have a buffer', ->
      expect(image.buffer).toBeDefined()

    it 'should have a data array', ->
      expect(image.data).toBeDefined()


    describe 'buffer', ->

      it 'should be an ArrayBuffer', ->
        expect(image.buffer).toBeType('ArrayBuffer')

    describe 'data', ->

      it 'should have the correct buffer', ->
        expect(image.data.buffer).toEqual image.buffer

      it 'should have the correct length', ->
        expect(image.data.length).toBe image.width*image.height

