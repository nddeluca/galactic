closest_power_of_two = (value,max) ->

  if value < max
    powerOfTwo = 1

    while powerOfTwo < value && powerOfTwo < max
      powerOfTwo = powerOfTwo << 1

    powerOfTwo
  else
    max

module?.exports = closest_power_of_two
