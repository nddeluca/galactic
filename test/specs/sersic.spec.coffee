examplesForImageInterface = require('../shared/image_examples')
examplesForModelInterface = require('../shared/model_examples')

Sersic = require('../../src/sersic')

require('../spec_helper')

describe 'Sersic', ->
  examplesForImageInterface(Sersic)
  examplesForModelInterface(Sersic)

  sersic = null
  params = null

  describe 'default parameters', ->

    beforeEach ->
      sersic = new Sersic(name: "Test")

    it "should have a centerX of half the width", ->
      expect(sersic.centerX).toEqual (sersic.width/2 - 1)

    it "should have a centerY of half the height", ->
      expect(sersic.centerY).toEqual (sersic.height/2 - 1)

    it 'should have an angle of zero', ->
      expect(sersic.angle).toEqual 0

    it 'should have an effective radius of the average quater distance from center', ->
      expect(sersic.effRadius).toEqual ((sersic.centerX + sersic.centerY)/4)

    it 'should have an axis ratio of 1', ->
      expect(sersic.axisRatio).toEqual 1

    it 'should have an intensity of 10', ->
      expect(sersic.intensity).toEqual 10

    it 'should have an n of 4', ->
      expect(sersic.n).toEqual 4

  describe 'setting parameters on construction', ->

    beforeEach ->
      params = { centerX: 1, centerY: 1, angle: Math.PI/2, axisRatio: 1.5, effRadius: 1, intensity: 1, n: 1}
      sersic = new Sersic(params)

    it 'should have the correct centerX accounting for zero indexing', ->
      expect(sersic.centerX).toEqual (params.centerX - 1)

    it 'should have the correct centerY accounting for zero indexing', ->
      expect(sersic.centerY).toEqual (params.centerY - 1)

    it 'should have the correct angle', ->
      expect(sersic.angle).toEqual params.angle

    it 'should have the correct axis ratio', ->
      expect(sersic.axisRatio).toEqual params.axisRatio

    it 'should have the correct effective radius', ->
      expect(sersic.effRadius).toEqual params.effRadius

    it 'should have the correct intensity', ->
      expect(sersic.intensity).toEqual params.intensity

    it 'should have the correct n', ->
      expect(sersic.n).toEqual params.n

  describe 'parameter updating', ->

    beforeEach ->
      sersic = new Sersic()

    it 'should update center x', ->
      centerX = Math.random()
      sersic.update_params(centerX: centerX)
      expect(sersic.centerX).toEqual centerX

    it 'should update center y', ->
      centerY = Math.random()
      sersic.update_params(centerY: centerY)
      expect(sersic.centerY).toEqual centerY

    it 'should update the angle', ->
      angle = Math.random()
      sersic.update_params(angle: angle)
      expect(sersic.angle).toEqual angle

    it 'should update axis ratio', ->
      ratio = Math.random()
      sersic.update_params(axisRatio: ratio)
      expect(sersic.axisRatio).toEqual ratio

    it 'should update the effective radius', ->
      radius = Math.random()
      sersic.update_params(effRadius: radius)
      expect(sersic.effRadius).toEqual radius

    it 'should update the intensity', ->
      intensity = Math.random()
      sersic.update_params(intensity: intensity)
      expect(sersic.intensity).toEqual intensity

    it 'should have the n', ->
      n = Math.random()
      sersic.update_params(n: n)
      expect(sersic.n).toEqual n


  describe 'data', ->
    results = null
    tolerance = null

    beforeEach ->
      sersic = new Sersic(name: "test", width: 4, height: 4, n: 4, intensity: 1, angle: Math.PI/2, axisRatio: 1.25, effRadius: 2)
      sersic.build()

      results = require('../data/sersic.data')

      tolerance = 5e-15

    it 'should be within the desired tolerance', ->
      expect(sersic.data).toBeCloseByElement(results,tolerance)


