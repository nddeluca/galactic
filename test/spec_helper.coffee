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
  )
)
