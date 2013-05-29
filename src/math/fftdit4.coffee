fft8_dit_core = require('./fft8dit')

fft_dit4_core = (fr,fi,ldn) ->
# Auxiliary routine for fft_dit4(
# Decimation in time (DIT) radix-4 FFT
# Input data must be in revbin_permuted order
#  ldn := base-2 logarithm of the array length
#  Fixed isign = +1
#
  M_PI = Math.PI
  sin = Math.sin
  cos = Math.cos

  n = 1 << ldn

  if n <= 2
    if n == 2
      st1 = fr[0]
      st2 = fr[1]
      fr[0] = st1 + st2
      fr[1] = st1 - st2

      st1 = fi[0]
      st2 = fi[1]
      fi[0] = st1 + st2
      fi[1] = st1 - st2

    return undefined

  ldm = (ldn&1)
  unless ldm == 0
    i0 = 0
    while i0 < n
      fft8_dit_core(fr,fi,i0)
      i0 += 4
  else
    i0 = 0
    while i0 < n
      i1 = i0 + 1
      i2 = i1 + 1
      i3 = i2 + 1

      st1 = fr[i0]
      st2 = fr[i1]
      xr = st1 + st2
      ur = st1 - st2

      st1 = fr[i2]
      st2 = fr[i3]
      yr = st1 + st2
      vi = st1 - st2

      st1 = fi[i0]
      st2 = fi[i1]
      xi = st1 + st2
      ui = st1 - st2

      st1 = fi[i3]
      st2 = fi[i2]
      yi = st1 + st2
      vr = st1 - st2

      fi[i1] = ui + vi
      fi[i3] = ui - vi

      fi[i0] = xi + yi
      fi[i2] = xi - yi

      fr[i1] = ur + vr
      fr[i3] = ur - vr

      fr[i0] = xr + yr
      fr[i2] = xr - yr

      i0 += 4

  ldm += 4

  while ldm <= ldn
    m = 1 << ldm
    m4 = m >>> 2
    ph0 = (2*M_PI)/m
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

        st1 = fr[i1]
        st2 = fi[i1]
        xr = st1*c2 - st2*s2
        xi = st2*c2 + st1*s2

        st1 = fr[i0]
        ur = st1 - xr
        xr = st1 + xr

        st1 = fi[i0]
        ui = st1 - xi
        xi = st1 + xi

        st1 = fr[i2]
        st2 = fi[i2]
        yr = st1*c - st2*s
        vr = st2*c + st1*s

        st1 = fr[i3]
        st2 = fi[i3]
        vi = st1*c3 - st2*s3
        yi = st2*c3 + st1*s3

        st1 = yr - vi
        yr = yr + vi
        vi = st1

        st1 = yi - vr
        yi = yi + vr
        vr = st1

        fr[i1] = ur + vr
        fr[i3] = ur - vr

        fi[i1] = ui + vi
        fi[i3] = ui - vi

        fr[i0] = xr + yr
        fr[i2] = xr - yr

        fi[i0] = xi + yi
        fi[i2] = xi - yi

        r += m
      j++
    ldm += 2

  return undefined

module?.exports = fft_dit4_core
