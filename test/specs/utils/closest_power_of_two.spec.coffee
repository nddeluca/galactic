closest_power_of_two = require('../../../src/utils/closest_power_of_two')

describe "Closest Power of Two", ->

  describe "Tests by Example", ->

    it "should return 128 when given a value of 100 and max of 512", ->
      expect(closest_power_of_two(100,512)).toEqual 128

    it "should return 256 when given a value of 168 and max of 256", ->
      expect(closest_power_of_two(168,256)).toEqual 256

    it "should return max when given a value greater", ->
      expect(closest_power_of_two(458,256)).toEqual 256

    it "should return 512 when given a value of 400 and max of 1024", ->
      expect(closest_power_of_two(400,1024)).toEqual 512

    it "should return 512 when given a value of 400 and max of 512", ->
      expect(closest_power_of_two(400,512)).toEqual 512
    
