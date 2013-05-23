revbin = require('../../src/bitutils/bitreverse')

describe 'bitreverse', ->
  describe 'reverse a 32-bit unsigned int', ->
    it 'should work on example 1', ->
      x = 0x0000ffff
      expect(revbin(x,32)).toBe 0xffff0000

    it 'should work on example 2', ->
      x = 0x12345678
      expect(revbin(x,32)).toBe 0x1E6A2C48

    it 'should work on example 3', ->
      x = 0x1F4B2D8A
      expect(revbin(x,32)).toBe 0x51B4D2F8
