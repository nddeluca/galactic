require('../spec_helper')
bitswap = require('../../src/utils/bitswap')

describe 'bitswap', -> 
  describe 'on unsigned intergers', ->

    it 'should swap single pairs', ->
      x = 0x55555555
      expect(bitswap.swap1(x)).toBe 0xAAAAAAAA

    it 'should swap pairs of two', ->
      x = 0x33333333
      expect(bitswap.swap2(x)).toBe 0xCCCCCCCC

    it 'should swap pairs of four', ->
      x = 0x0f0f0f0f
      expect(bitswap.swap4(x)).toBe 0xf0f0f0f0

    it 'should swap pairs of eight', ->
      x = 0x00ff00ff
      expect(bitswap.swap8(x)).toBe 0xff00ff00

    it 'should swap pairs of sixteen', ->
      x = 0x0000ffff
      expect(bitswap.swap16(x)).toBe 0xffff0000
