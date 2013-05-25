arrayutils = require('../utils/arrayutils')

fft =
  realfft: (x,n) ->
    #n in the length of the array x
    #n = 2^ldn
    #
    #Re-order the array
    arrayutils.revbin_permute(x,n/2)

    #Cache these in local scope
    TWO_PI = 2*Math.PI
    SQRT1_2 = Math.SQRT1_2
    sin = Math.sin
    cos = Math.cos

    #START OUTER LOOP 1
    ix = 0
    id = 4
    while ix < n
      i0 = ix
      while i0 < n
        st1 = x[i0]
        st2 = x[i0+1]
        x[i0] = st1 + st2
        x[i0+1] = st1 - st2
        i0 = i0 + id
      ix = (id-1) << 1
      id = id << 2
    #END OUT LOOP 1

    #START OUTER LOOP 2
    n2 = 2
    nn = n >>> 1
    while nn = nn >>> 1
      ix = 0
      n2 = n2 << 1
      id = n2 << 1
      n4 = n2 >>> 2
      n8 = n2 >>> 3
      #START DO-WHILE 1
      while true
        #START INNER LOOP 1
        i0 = ix
        while i0 < n
          i1 = i0
          i2 = i1 + n4
          i3 = i2 + n4
          i4 = i3 + n4
          st1 = x[i3]
          st2 = x[i4]
          t3 = st1 + st2
          x[i4] = st2 - st1
          st1 = x[i1]
          x[i3] = st1 - t3
          x[i1] = st1 + t3
          #START IF
          unless n4 == 1
            i1 = i1 + n8
            i2 = i2 + n8
            i3 = i3 + n8
            i4 = i4 + n8
            st1 = x[i3]
            st2 = x[i4]
            t1 = st1 + st2
            t2 = st1 - st2
            t1 = -t1*SQRT1_2
            t2 = t2*SQRT1_2
            st1 = x[i2]
            x[i4] = t1 + st1
            x[i3] = t1 - st1
            st1 = x[i1]
            x[i2] = st1 - t2
            x[i1] = st1 + t2
          #END IF
          i0 = i0 + id
        #END INNER LOOP 1
        ix = (id << 1) - n2
        id = id << 2
        break unless ix < n
      #END DO WHILE 1
      e = (TWO_PI)/n2
      #START INNER LOOP 2
      j = 1
      while j < n8
        a = j*e
        ss1 = sin(a)
        cc1 = cos(a)
        cc3 = 4*cc1*(cc1*cc1-0.75)
        ss3 = 4*ss1*(0.75-ss1*ss1)
        #START DO-WHILE 2
        ix = 0
        id = n2 << 1
        while true
          #START INNER LOOP 3
          i0 = ix
          while i0 < n
            i1 = i0 + j
            i2 = i1 + n4
            i3 = i2 + n4
            i4 = i3 + n4
            i5 = i0 + n4 - j
            i6 = i5 + n4
            i7 = i6 + n4
            i8 = i7 + n4
            st1 = x[i3]
            st2 = x[i7]
            t1 = cc1*st1 + ss1*st2
            t2 = cc1*st2 - ss1*st1
            st1 = x[i4]
            st2 = x[i8]
            t3 = cc3*st1 + ss3*st2
            t4 = cc3*st2 - ss3*st1
            t5 = t1 + t3
            t6 = t2 + t4
            t3 = t1 - t3
            t4 = t2 - t4
            st1 = x[i6]
            t2 = t6 + st1
            x[i3] = t6 - st1
            x[i8] = t2
            st1 = x[i2]
            t2 = st1 - t3
            x[i7] = -st1 - t3
            x[i4] = t2
            st1 = x[i1]
            t1 = st1 + t5
            x[i6] = st1 - t5
            x[i1] = t1
            x[i5] = x[i5] - t4
            x[i2] = t1
            i0 = i0 + id
          #END INNER LOOP 3
          ix = (id << 1) - n2
          id = id << 2
          break unless ix < n
        #END DO-WHILE 2
        j = j + 1
      #END INNER LOOP 2
    #END OUTER LOOP 2
    undefined

module?.exports = fft
