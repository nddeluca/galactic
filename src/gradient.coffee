
class Gradient
  
  constructor: ->
    @max = 255
    @buffer = new ArrayBuffer(@range*4)
    @gradient = new Uint32Array(@buffer)
    @entries = []

  add: (level,intensity) ->
    entry = {
      level: level
      intensity: intensity }
    @entries.push(entry)

  build: ->
    entries = @entries
    i = entries.length-1
    while i--
      entry1 = entries[i]
      entry2 = entries[i+1]

      level1 = entry1.level
      level2 = entry2.level
      intensity1 = entry1.intensity
      intensity2 = entry2.intensity

      range = level2 - level1
      invRange = 1/range
      
     
      for j in [range..0]
        value = (intensity2-intensity1)*j*invRange + intensity1
        @gradient[level1 + range] = ~~(255*value)
        





module?.exports = Gradient
