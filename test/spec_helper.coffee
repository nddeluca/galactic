beforeEach( ->
  this.addMatchers(
    toBeType: (expected) ->
      type = Object.prototype.toString.call(this.actual).slice(8,-1)
      type == expected

    toBeAFunction: () ->
      type = Object.prototype.toString.call(this.actual).slice(8,-1)
      type == 'Function'

    toBeInstanceOf: (expected) ->
      this.actual instanceof expected


    toBeCloseByElement: (expected,tolerance) ->
      actual = @actual
      i = actual.length
      while i--
        error = Math.abs(actual[i] - expected[i])
        if error > tolerance
          @message = ->
            "Expected element " + i + ", " + expected[i] + " to be within " + tolerance + " of actual element " + i + ", " + actual[i]
          return false
      return true

  )
)
