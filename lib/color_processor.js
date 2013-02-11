// Generated by CoffeeScript 1.3.3
(function() {
  var ColorProcessor;

  ColorProcessor = function(algorithm) {
    return {
      process: function(stretchData, colorData) {
        return algorithm(stretchData, colorData);
      }
    };
  };

  if (typeof module !== "undefined" && module !== null) {
    module.exports = ColorProcessor;
  }

}).call(this);