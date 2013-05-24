utils = require('../../src/utils/arrayutils')

describe 'utils', ->

  it 'can find the maximum of an array', ->
    array = [-10,-5,0,-5,10]
    result = utils.max(array)
    expect(result).toBe 10

  it 'can find the minimum of an array', ->
    array = [-10,-5,0,-5,10]
    result = utils.min(array)
    expect(result).toBe -10

  describe 'array permutation by swapping bit reversed indicies', ->
    it 'swaps the correct indicies for an array of length 32', ->
      array = [0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31]
      n = array.length
      result = [0,16,8,24,4,20,12,28,2,18,10,26,6,22,14,30,1,17,9,25,5,21,13,29,3,19,11,27,7,23,15,31]
      utils.revbin_permute(array,n)
      expect(array).toEqual result

    it 'swaps the correct indicies for an array of legnth 16', ->
      array = [0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15]
      n = array.length
      result = [0,8,4,12,2,10,6,14,1,9,5,13,3,11,7,15]
      utils.revbin_permute(array,n)
      expect(array).toEqual result

    it 'swaps the correct indicies for an array of length 8', ->
      array = [0,1,2,3,4,5,6,7]
      n = array.length
      result = [0,4,2,6,1,5,3,7]
      utils.revbin_permute(array,n)
      expect(array).toEqual result

    it 'swaps the correct indicies for an array of length 4', ->
      array = [0,1,2,3]
      n = array.length
      result = [0,2,1,3]
      utils.revbin_permute(array,n)
      expect(array).toEqual result

    it 'should not swap any elements in an array of length 2', ->
      array = [0,1]
      n = array.length
      result = [0,1]
      utils.revbin_permute(array,n)
      expect(array).toEqual result
      
