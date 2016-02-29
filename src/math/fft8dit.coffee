# This function is derived from the
# FXT Library (http://www.jjj.de/fxt/fxtpage.html)
# by Joerg Arndt
#
# Original copyright from fxt/fft/fft8ditcore.cc:
#
# This file is part of the FXT library.
# Copyright (C) 2010, 2012 Joerg Arndt
# License: GNU General Public License version 3 or later,
# see the file COPYING.txt in the main directory.

fft8_dit_core = (fr,fi,offset) ->
# 8-point decimation in time FFT
# isign = +1
# input data must be in revbin_permuted order
#.
# Cf. Nussbaumer p.148f

  i0 = 0 + offset
  i1 = i0 + 1
  i2 = i0 + 2
  i3 = i0 + 3
  i4 = i0 + 4
  i5 = i0 + 5
  i6 = i0 + 6
  i7 = i0 + 7

  M_SQRT1_2 = Math.SQRT1_2


  # INPUT_RE:
  t1r = fr[i0] + fr[i1]
  t2r = fr[i2] + fr[i3]
  t7r = t1r + t2r
  t3r = fr[i4] - fr[i5]
  t4r = fr[i4] + fr[i5]
  t5r = fr[i6] + fr[i7]
  t8r = t4r + t5r
  t6r = fr[i6] - fr[i7]

  m0r = t7r + t8r
  m1r = t7r - t8r
  m2r = t1r - t2r
  m3r = fr[i0] - fr[i1]
  m4r = M_SQRT1_2 * (t3r - t6r)
  t8r = M_SQRT1_2 * (t3r + t6r)
  t6r = t5r - t4r
  t7r = fr[i3] - fr[i2]

    # INPUT_IM:
  t1i = fi[i0] + fi[i1]
  t2i = fi[i2] + fi[i3]
  t7i = t1i + t2i
  t3i = fi[i4] - fi[i5]
  t4i = fi[i4] + fi[i5]
  t5i = fi[i6] + fi[i7]
  t8i = t4i + t5i
  t6i = fi[i6] - fi[i7]

  m0i = t7i + t8i
  m1i = t7i - t8i
  m2i = t1i - t2i
  m3i = fi[i0] - fi[i1]
  m4i = M_SQRT1_2 * (t3i - t6i)

  t8i = M_SQRT1_2 * (t3i + t6i)
  t6i = t4i - t5i
  t7i = fi[i2] - fi[i3]

  t1r = m3r + m4r
  t2r = m3r - m4r
  t3r = t7i + t8i
  t4r = t7i - t8i

  # OUTPUT_RE:
  fr[i0] = m0r
  fr[i7] = t1r + t3r
  fr[i6] = m2r + t6i
  fr[i5] = t2r - t4r
  fr[i4] = m1r
  fr[i3] = t2r + t4r
  fr[i2] = m2r - t6i
  fr[i1] = t1r - t3r

  t1r = m3i + m4i
  t2r = m3i - m4i
  t3r = t7r - t8r
  t4r = t7r + t8r

    # OUTPUT_IM:
  fi[i0] = m0i
  fi[i7] = t1r + t3r
  fi[i6] = m2i + t6r
  fi[i5] = t2r - t4r
  fi[i4] = m1i
  fi[i3] = t2r + t4r
  fi[i2] = m2i - t6r
  fi[i1] = t1r - t3r

  undefined

module?.exports = fft8_dit_core
