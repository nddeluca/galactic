require('../spec_helper')

Colormap = require('../../src/colormap')
colors = require('../../src/colors')

describe 'Colormap', ->
  colormap = null

  beforeEach ->
    colormap = new Colormap(colors.gray)

  describe 'instance variables', ->

    it 'should have a buffer', ->
      expect(colormap.buffer).toBeDefined()

    it 'should have a pixelmap', ->
      expect(colormap.pixelMap).toBeDefined()

    it 'should have a map', ->
      expect(colormap.map).toBeDefined()

    describe 'buffer', ->

      it 'should have bytelength 1024', ->
        expect(colormap.buffer.byteLength).toBe 1024
      
      it 'should be an ArrayBuffer', ->
        expect(colormap.buffer).toBeType('ArrayBuffer')

    describe 'pixelmap', ->

      it 'should have length 256', ->
        expect(colormap.pixelMap.length).toBe 256

      it 'should be an Uint32Array', ->
        expect(colormap.pixelMap).toBeType('Uint32Array')

      it 'should be associated with the correct buffer', ->
        expect(colormap.pixelMap.buffer).toEqual colormap.buffer

  describe 'instance methods', ->
    
    it 'should have a setMap function', ->
      expect(colormap.setMap).toBeAFunction()

    it 'should have a loadLUT function', ->
      expect(colormap.loadLUT).toBeAFunction()

    it 'should have loadSAO function', ->
      expect(colormap.loadSAO).toBeAFunction()
