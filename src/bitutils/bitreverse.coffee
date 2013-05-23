bitswap = require('./bitswap')

revbin = (x, ldn) ->
  x = bitswap.swap1(x)
  x = bitswap.swap2(x)
  x = bitswap.swap4(x)
  x = bitswap.swap8(x)
  x = bitswap.swap16(x)
  x >>> (32-ldn)

module?.exports = revbin
