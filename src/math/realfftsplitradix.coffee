arrayutils = require('../utils/arrayutils')

fft =
  realfft: (x,n) ->
    #n in the length of the array x
    #n = 2^ldn
    arrayutils.revbin_permute(x,n/2)

    ix = 0
    id = 4

    while ix < n
      i0 = ix
      while i0 < n
        temp = x[i0] - x[i0+1]
        x[i0] = x[i0] + x[i0+1]
        x[i0+1] = temp
        i0 = i0 + id
      ix = 2*(id-1)
      id = 4*id

    n2 = 2
    nn = n >>> 1

    #START MAIN
    while nn = nn >>> 1
      ix = 0
      n2 = n2 << 1
      id = n2 << 1
      n4 = n2 >>> 2
      n8 = n2 >>> 3

      #START DO-WHILE
      while true

        #START INNER LOOP 1
        i0 = ix
        while i0 < n
          i1 = i0
          i2 = i1 + n4
          i3 = i2 + n4
          i4 = i3 + n4

          t1 = x[i3] + x[i4]
          x[i4] = x[i4] - x[i3]

          x[i3] = x[i1] - t1
          x[i1] = x[i1] + t1

          #START IF
          unless n4 == 1
            i1 = i1 + n8
            i2 = i2 + n8
            i3 = i3 + n8
            i4 = i4 + n8

            t1 = x[i3] + x[i4]
            t2 = x[i3] - x[i4]

            t1 = -t1*Math.SQRT1_2
            t2 = t2*Math.SQRT1_2

            st1 = x[i2]
            x[i4] = t1 + st1
            x[i3] = t1 - st1

            x[i2] = x[i1] - t2
            x[i1] = x[i1] + t2

          #END IF

          i0 = i0 + id
        #END INNER LOOP

        ix = (id << 1) - n2
        id = id << 2

        break unless ix < n
      #END DO WHILE
      
      e = (2.0*Math.PI)/n2
      
      #START INNER LOOP
      j = 1
      while j < n8
        a = j*e

        ss1 = Math.sin(a)
        cc1 = Math.cos(a)

        cc3 = 4*cc1*(cc1*cc1-0.75)
        ss3 = 4*ss1*(0.75-ss1*ss1)

        #START DO-WHILE
        ix = 0
        id = n2 << 1
        while true
          
          #START INNER LOOP
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

            t1 = cc1*x[i3] + ss1*x[i7]
            t2 = cc1*x[i7] - ss1*x[i3]

            t3 = cc3*x[i4] + ss3*x[i8]
            t4 = cc3*x[i8] - ss3*x[i4]

            t5 = t1 + t3
            t6 = t2 + t4
            t3 = t1 - t3
            t4 = t2 - t4

            t2 = t6 + x[i6]
            x[i3] = t6 - x[i6]
            x[i8] = t2
            t2 = x[i2] - t3
            x[i7] = -x[i2] - t3
            x[i4] = t2
            t1 = x[i1] + t5
            x[i6] = x[i1] - t5
            x[i1] = t1
            x[i5] = x[i5] - t4
            x[i2] = t1

            i0 = i0 + id
          #END INNER LOOP
          ix = (id << 1) - n2
          id = id << 2
          break unless ix < n
        #END DO-WHILE
        j = j + 1
      #END INNER LOOP
    #END MAIN
    undefined

module?.exports = fft
