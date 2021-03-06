// Generated by CoffeeScript 1.6.3
(function() {
  var bitswap, revbin;

  bitswap = require('./bitswap');

  revbin = function(x, ldn) {
    x = bitswap.swap1(x);
    x = bitswap.swap2(x);
    x = bitswap.swap4(x);
    x = bitswap.swap8(x);
    x = bitswap.swap16(x);
    return x >>> (32 - ldn);
  };

  if (typeof module !== "undefined" && module !== null) {
    module.exports = revbin;
  }

}).call(this);
