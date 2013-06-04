examplesForModelInterface = (modelObject) ->

  describe 'Model Interface', ->
    model = null
    name = null

    beforeEach ->
      name = "Test Model"
      model = new modelObject(name: name)

    it 'should have the name set to the correct value', ->
      expect(model.name).toEqual name

    it 'should be enabled by default', ->
      expect(model.enabled).toBeTruthy()

    it 'should be stale by default', ->
      expect(model.stale).toBeTruthy()

    it 'should be allowed to be disabled on contruction', ->
      model = new modelObject(enabled: false)
      expect(model.enabled).toBeFalsy()

    it 'should be allowed to be enabled on construction', ->
      model = new modelObject(enabled: true)
      expect(model.enabled).toBeTruthy()

    it 'should be allowed to be stale on construction', ->
      model = new modelObject(stale: true)
      expect(model.enabled).toBeTruthy()

    it 'should be allowed not to be stale on construction', ->
      model = new modelObject(stale: false)
      expect(model.stale).toBeFalsy()

    describe 'Hook for setting up parameters', ->
      args = null

      beforeEach ->
        args = name: "Test Args", param1: "value1", param2: "value2"
        spyOn(model,'set_up_parameters')
        model.post_initialize(args)

      it "should be called on construction", ->
        expect(model.set_up_parameters).toHaveBeenCalled()

      it "should be passed the correct arguments", ->
        expect(model.set_up_parameters).toHaveBeenCalledWith(args)


    describe 'Hook for updating parameters', ->
      params = null

      beforeEach ->
        params = param1: "value1", param2: "value2"
        spyOn(model,'on_params_update')
        model.update_params(params)

      it "should be called after update_params", ->
        expect(model.on_params_update).toHaveBeenCalled()

      it 'should be passed the correct arguments', ->
        expect(model.on_params_update).toHaveBeenCalledWith(params)

    describe 'hook for calculating model', ->

      beforeEach ->
        spyOn(model,'calculate')
        model.build()

      it 'should be called after build', ->
        expect(model.calculate).toHaveBeenCalled()


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
        model.update_params(null)
        expect(model.stale).toBe true


module?.exports = examplesForModelInterface
