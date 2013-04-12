Model = require('../../src/model')
Image = require('../../src/image')

describe 'Model', ->
  model = null

  beforeEach ->
    model = new Model('test',500,500)
 
  describe 'instance variables', ->

    it 'should have enabled defined', ->
      expect(model.enabled).toBeDefined()

    it 'should have stale defiend', ->
      expect(model.stale).toBeDefined()

    it 'should have params defined', ->
      expect(model.params).toBeDefined()

    it 'should have paramArray defined', ->
      expect(model.paramArray).toBeDefined()

    it 'should have name defined', ->
      expect(model.name).toBeDefined()

    it 'should have width defeind', ->
      expect(model.width).toBeDefined()

    it 'should have height defined()', ->
      expect(model.height).toBeDefined()

  describe 'instance methods', ->
    
    it 'should have an enable function', ->
      expect(model.enable).toBeAFunction()

    it 'should have a disable function', ->
      expect(model.disable).toBeAFunction()

    it 'should have an updateParams function', ->
      expect(model.updateParams).toBeAFunction()

    it 'should have a build function', ->
      expect(model.build).toBeAFunction()


  describe 'initial values', ->

    it 'should be enabled', ->
      expect(model.enabled).toBeTruthy()

    it 'should be stale', ->
      expect(model.stale).toBeTruthy()

    it 'should have the correct name', ->
      expect(model.name).toBe 'test'

    it 'should have the correct width', ->
      expect(model.width).toBe 500

    it 'should have the correct height', ->
      expect(model.height).toBe 500

  describe 'state', ->

    it 'can be disabled', ->
      model.enabled = true
      model.disable()
      expect(model.enabled).toBe false

    it 'can be enabled', ->
      model.enabled = false
      model.enable()
      expect(model.enabled).toBe true

    it 'should not be stale after build', ->
      model.stale = true
      model.build()
      expect(model.stale).toBe false

    it 'should be stale after params are updated', ->
      model.stale = false
      model.updateParams(null)
      expect(model.stale).toBe true

  it 'should allow params to be updated', ->
    params =
      test: 1
      test: "2"
    model.updateParams(params)
    expect(model.params).toEqual params

  it 'should extend Image', ->
    expect(model).toBeInstanceOf(Image)
