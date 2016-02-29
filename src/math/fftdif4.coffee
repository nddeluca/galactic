# This function is derived from the
# FXT Library (http://www.jjj.de/fxt/fxtpage.html)
# by Joerg Arndt
#
# Original copyright from fxt/fft/fftdif4.cc:
#
# This file is part of the FXT library.
# Copyright (C) 2010, 2011, 2012, 2014 Joerg Arndt
# License: GNU General Public License version 3 or later,
# see the file COPYING.txt in the main directory.

fft8_dif_core = require('./fft8dif')

fft_dif4_core = (fr,fi,ldn) ->
# Auxiliary routine for fft_dif4().
# Decimation in frequency (DIF) radix-4 FFT.
# Output data is in revbin_permuted order.
# ldn := base-2 logarithm of the array length.
# Fixed isign = +1
#
  M_PI = Math.PI
  sin = Math.sin
  cos = Math.cos

  #Turn into n and ldn
  n = 1 << ldn

  if n <= 2
    if n == 2
      st1 = fr[0]
      st2 = fr[1]
      t1 = st1 - st2
      fr[0] = st1 + st2
      fr[1] = t1

      st1 = fi[0]
      st2 = fi[1]
      t1 = st1 - st2
      fr[0] = st1 + st2
      fr[1] = t1
    return undefined

  ldm = ldn
  while ldm >= 4
    m = 1 << ldm
    m4 = m >>> 2

    ph0 = (2 * M_PI)/m
    ph = 0

    j = 0
    while j < m4
      s = sin(ph)
      c = cos(ph)
      ph += ph0

      c2 = c*c - s*s
      s2 = c*s
      s2 += s2

      c3 = c2*c - s2*s
      s3 = s2*c + c2*s

      r = 0
      while r < n
        i0 = j + r
        i1 = i0 + m4
        i2 = i1 + m4
        i3 = i2 + m4

        st1 = fr[i0]
        st2 = fr[i2]
        xr = st1 + st2
        ur = st1 - st2

        st1 = fi[i0]
        st2 = fi[i2]
        xi = st1 + st2
        ui = st1 - st2

        st1 = fr[i1]
        st2 = fr[i3]
        yr = st1 + st2
        vi = st1 - st2

        st1 = fi[i3]
        st2 = fi[i1]
        yi = st1 + st2
        vr = st1 - st2

        fr[i0] = xr + yr
        yr = xr - yr

        fi[i0] = xi + yi
        yi = xi - yi

        fr[i1] = yr*c2 - yi*s2
        fi[i1] = yi*c2 + yr*s2

        xr = ur + vr
        yr = ur - vr
        xi = ui + vi
        yi = ui - vi

        fr[i3] = yr*c3 - yi*s3
        fi[i3] = yi*c3 + yr*s3

        fr[i2] = xr*c - xi*s
        fi[i2] = xi*c + xr*s

        r += m
      j++
    ldm -= 2


  unless (ldn&1) == 0
    i0 = 0
    while i0 < n
      fft8_dif_core(fr,fi,i0)
      i0 += 8
  else
    i0 = 0
    while i0 < n
      i1 = i0 + 1
      i2 = i1 + 1
      i3 = i2 + 1

      st1 = fr[i0]
      st2 = fr[i2]
      xr = st1 + st2
      ur = st1 - st2

      st1 = fr[i1]
      st2 = fr[i3]
      yr = st1 + st2
      vi = st1 - st2

      st1 = fi[i0]
      st2 = fi[i2]
      xi = st1 + st2
      ui = st1 - st2

      st1 = fi[i3]
      st2 = fi[i1]
      yi = st1 + st2
      vr = st1 - st2

      fi[i0] = xi + yi
      fi[i1] = xi - yi

      fi[i2] = ui + vi
      fi[i3] = ui - vi

      fr[i0] = xr + yr
      fr[i1] = xr - yr

      fr[i2] = ur + vr
      fr[i3] = ur - vr

      i0 += 4

  undefined

module?.exports = fft_dif4_core
