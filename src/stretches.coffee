#Contains the different functions used to stretch the image on the display.
stretches =
  linear: (imageData,colorData,pixelMap,min,max) ->
    invRange = 1/(max-min)
    i = imageData.length
    while i--
      level = ~~(255*((imageData[i] - min)*invRange))
      colorData[i] = pixelMap[level]
    undefined

  log: (imageData,colorData,pixelMap,min,max) ->
    range = max - min
    invLN10 = 1/Math.LN10
    invMaxLog = 1/(Math.log(range)*invLN10)
    
    i = imageData.length
    while i--
       colorData[i] = pixelMap[~~(255*((Math.log(imageData[i] - min + 1)*invLN10)*invMaxLog))]
    undefined

  power: (imageData,colorData,pixelMap,min,max) ->
    range = max - min
    invMaxPow = 1/(range*range)

    
    i = imageData.length
    while i--
      value = imageData[i] - min
      colorData[i] = pixelMap[~~(255*((value*value)*invMaxPow))]
    undefined

  sqrt: (imageData,colorData,pixelMap,min,max) ->
    range = max - min
    invMaxSqrt = 1/Math.sqrt(range)

    i = imageData.length
    while i--
      colorData[i] = pixelMap[~~(255*((Math.sqrt(imageData[i] - min))*invMaxSqrt))]
    undefined

  arcsinh: (imageData,colorData,pixelMap,min,max) ->
    range = max - min
    max_asinh = Math.log(range + Math.sqrt(range*range + 1))
    invMaxAsinh = 1/max_asinh
    i = imageData.length
    while i--
      point = imageData[i] - min
      value = Math.log(point + Math.sqrt(point*point + 1))
      colorData[i] = pixelMap[~~(255*(value*invMaxAsinh))]
    undefined

module?.exports = stretches
