// Generated by CoffeeScript 1.6.3
(function() {
  var closest_power_of_two;

  closest_power_of_two = function(value, max) {
    var powerOfTwo;
    if (value < max) {
      powerOfTwo = 1;
      while (powerOfTwo < value && powerOfTwo < max) {
        powerOfTwo = powerOfTwo << 1;
      }
      return powerOfTwo;
    } else {
      return max;
    }
  };

  if (typeof module !== "undefined" && module !== null) {
    module.exports = closest_power_of_two;
  }

}).call(this);
