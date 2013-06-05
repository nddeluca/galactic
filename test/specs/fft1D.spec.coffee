fft_dif4_core = require('../../src/math/fftdif4')
fft_dit4_core = require('../../src/math/fftdit4')
arrayutils = require('../../src/utils/arrayutils')

require('../spec_helper')

describe '1D FFTs', ->
  orig_real = null
  orig_imag = null
  real = null
  imag = null
  results = null
  inverse_results = null
  tolerance = null
  n = null
  ldn = null


  describe 'Radix-4 DIF FFT', ->

    beforeEach ->
      n = 128
      ldn = Math.log(n)/Math.LN2

      real = []
      imag = []

      l = 4*Math.PI

      for i in [0..n-1]
        real[i] = Math.sin(i*(l/(n-1)))
      for i in [0..n-1]
        imag[i] = 0


      results = require('../data/fft_test.data')
      inverse_results = require('../data/fft_inverse.data')
      tolerance = 5e-14

    it 'should have real values within tolerenace to matlab output for -1 sign transform', ->
      fft_dif4_core(imag,real,ldn)
      arrayutils.revbin_permute(real,n)
      arrayutils.revbin_permute(imag,n)
      expect(real).toBeCloseByElement(results.real,tolerance)

    it 'should have imaginary values within tolerance to matlab output for -1 sign transform', ->
      fft_dif4_core(imag,real,ldn)
      arrayutils.revbin_permute(real,n)
      arrayutils.revbin_permute(imag,n)
      expect(imag).toBeCloseByElement(results.imag,tolerance)

    it 'should have real values within tolerance to matlab output for +1 sign transform', ->
      fft_dif4_core(real,imag,ldn)
      arrayutils.revbin_permute(real,n)
      arrayutils.revbin_permute(imag,n)

      i = n
      while i--
        real[i] = real[i]*(1/n)

      expect(real).toBeCloseByElement(inverse_results.real,tolerance)

    it 'should have imaginary values within tolerance to matlab output for +1 sign transform', ->
      fft_dif4_core(real,imag,ldn)
      arrayutils.revbin_permute(real,n)
      arrayutils.revbin_permute(imag,n)

      i = n
      while i--
        imag[i] = imag[i]*(1/n)

      expect(imag).toBeCloseByElement(inverse_results.imag,tolerance)

  describe 'Radix-4 DIT FFT', ->

    beforeEach ->
      n = 128
      ldn = Math.log(n)/Math.LN2

      real = []
      imag = []

      l = 4*Math.PI

      for i in [0..n-1]
        real[i] = Math.sin(i*(l/(n-1)))
      for i in [0..n-1]
        imag[i] = 0

      results = require('../data/fft_test.data')
      inverse_results = require('../data/fft_inverse.data')
      tolerance = 5e-13

    it 'should have real values within tolerenace to matlab output for -1 sign transform', ->
      arrayutils.revbin_permute(real,n)
      arrayutils.revbin_permute(imag,n)
      fft_dit4_core(imag,real,ldn)
      expect(real).toBeCloseByElement(results.real,tolerance)

    it 'should have imaginary values within tolerance to matlab output for -1 sign transform', ->
      arrayutils.revbin_permute(real,n)
      arrayutils.revbin_permute(imag,n)
      fft_dit4_core(imag,real,ldn)
      expect(imag).toBeCloseByElement(results.imag,tolerance)

    it 'should have real values within tolerance to matlab output for +1 sign transform', ->
      arrayutils.revbin_permute(real,n)
      arrayutils.revbin_permute(imag,n)
      fft_dit4_core(real,imag,ldn)

      i = n
      while i--
        real[i] = real[i]*(1/n)

      expect(real).toBeCloseByElement(inverse_results.real,tolerance)

    it 'should have imaginary values within tolerance to matlab output for +1 sign transform', ->
      arrayutils.revbin_permute(real,n)
      arrayutils.revbin_permute(imag,n)
      fft_dit4_core(real,imag,ldn)

      i = n
      while i--
        imag[i] = imag[i]*(1/n)

      expect(imag).toBeCloseByElement(inverse_results.imag,tolerance)



