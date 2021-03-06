// Generated by CoffeeScript 1.6.3
(function() {
  var bitswap;

  bitswap = {
    swap1: function(x) {
      var m;
      m = 0x55555555;
      return (((x & m) << 1) | ((x & (~m)) >>> 1)) >>> 0;
    },
    swap2: function(x) {
      var m;
      m = 0x33333333;
      return (((x & m) << 2) | ((x & (~m)) >>> 2)) >>> 0;
    },
    swap4: function(x) {
      var m;
      m = 0x0f0f0f0f;
      return (((x & m) << 4) | ((x & (~m)) >>> 4)) >>> 0;
    },
    swap8: function(x) {
      var m;
      m = 0x00ff00ff;
      return (((x & m) << 8) | ((x & (~m)) >>> 8)) >>> 0;
    },
    swap16: function(x) {
      return ((x << 16) | (x >>> 16)) >>> 0;
    }
  };

  if (typeof module !== "undefined" && module !== null) {
    module.exports = bitswap;
  }

}).call(this);
