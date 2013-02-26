#Contains the different functions used to stretch the image on the display.
stretches =
  linear: (imageData,stretchData,min,max) ->
    invRange = 1/(max-min)
    i = stretchData.length
    while i--
      stretchData[i] = ~~(255*((imageData[i] - min)*invRange))
    undefined

  log: (imageData,stretchData,min,max) ->
    range = max - min
    invLN10 = 1/Math.LN10
    invMaxLog = 1/(Math.log(range)*invLN10)
    
    i = stretchData.length
    while i--
      stretchData[i] = ~~(255*((Math.log(imageData[i] - min + 1)*invLN10)*invMaxLog))
    undefined

  power: (imageData,stretchData,min,max) ->
    range = max - min
    invMaxPow = 1/(range*range)

    
    i = stretchData.length
    while i--
      value = imageData[i] - min
      stretchData[i] = ~~(255*((value*value)*invMaxPow))
    undefined

  sqrt: (imageData,stretchData,min,max) ->
    range = max - min
    invMaxSqrt = 1/Math.sqrt(range)

    i = stretchData.length
    while i--
      stretchData[i] = ~~(255*((Math.sqrt(imageData[i] - min))*invMaxSqrt))
    undefined

  arcsinh: (imageData,stretchData,min,max) ->
    range = max - min
    max_asinh = Math.log(range + Math.sqrt(range*range + 1))
    invMaxAsinh = 1/max_asinh
    i = stretchData.length
    while i--
      point = imageData[i] - min
      value = Math.log(point + Math.sqrt(point*point + 1))
      stretchData[i] = ~~(255*(value*invMaxAsinh))
    undefined

module?.exports = stretches
