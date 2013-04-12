utils = require('../../src/utils')

describe 'utils', ->
  
  it 'can find the maximum of an array', ->
    array = [-10,-5,0,-5,10]
    result = utils.max(array)
    expect(result).toBe 10

  it 'can find the minimum of an array', ->
    array = [-10,-5,0,-5,10]
    result = utils.min(array)
    expect(result).toBe -10
