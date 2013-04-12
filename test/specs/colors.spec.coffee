colors = require('../../src/colors')

describe 'colors', ->

  describe 'gray', ->
    color = null

    beforeEach ->
      color = colors.gray

    it 'should have type SAO', ->
      expect(color.type).toBe "SAO"

    describe 'red', ->
      red = null

      beforeEach ->
        red = color.red

      it 'should have the correct level', ->
        expect(red.level).toEqual [0,1]
      
      it 'should have the correct intensity', ->
        expect(red.intensity).toEqual [0,1]

    describe 'green', ->
      green = null

      beforeEach ->
        green = color.green

      it 'should have the correct level', ->
        expect(green.level).toEqual [0,1]

      it 'should have the correct intensity', ->
        expect(green.intensity).toEqual [0,1]

    describe 'blue', ->
      blue = null

      beforeEach ->
        blue = color.blue
      
      it 'should have the correct level', ->
        expect(blue.level).toEqual [0,1]

      it 'should have the correct intensity', ->
        expect(blue.intensity).toEqual [0,1]

