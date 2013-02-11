// Generated by CoffeeScript 1.3.3
(function() {
  var models;

  models = {
    sersic: function(params, data, width, height) {
      var cos, exponent, norm, r, r_x, r_y, sin, x, y, _i, _j, _ref, _ref1;
      norm = params.n * Math.exp(0.6950 - 0.1789 / params.n);
      sin = Math.sin(params.angle);
      cos = Math.cos(params.angle);
      for (x = _i = 0, _ref = width - 1; 0 <= _ref ? _i <= _ref : _i >= _ref; x = 0 <= _ref ? ++_i : --_i) {
        for (y = _j = _ref1 = height - 1; _ref1 <= 0 ? _j <= 0 : _j >= 0; y = _ref1 <= 0 ? ++_j : --_j) {
          r_x = (x - params.center.x) * cos + (y - params.center.y) * sin;
          r_y = ((y - params.center.y) * cos - (x - params.center.x) * sin) / params.axisRatio;
          r = Math.sqrt(r_x * r_x + r_y * r_y);
          exponent = norm * Math.pow(r / params.effRadius, 1 / params.n) - 1;
          data[y * width + x] = params.intensity * Math.exp(-exponent);
        }
      }
      return void 0;
    },
    basicSersic: function(params, data, width, height) {
      var exponent, norm, r, x, x_cent, x_sqr, y, y_cent, _i, _j, _ref, _ref1;
      norm = params.n * Math.exp(0.6950 - 0.1789 / params.n);
      for (x = _i = 0, _ref = width - 1; 0 <= _ref ? _i <= _ref : _i >= _ref; x = 0 <= _ref ? ++_i : --_i) {
        x_cent = x - params.center.x;
        x_sqr = x_cent * x_cent;
        for (y = _j = _ref1 = height - 1; _ref1 <= 0 ? _j <= 0 : _j >= 0; y = _ref1 <= 0 ? ++_j : --_j) {
          y_cent = y - params.center.y;
          r = Math.sqrt(x_sqr + y_cent * y_cent);
          exponent = params.coeff * Math.pow(r / params.effRadius, 1 / params.n) - 1;
          data[y * width + x] = params.intensity * Math.exp(-exponent);
        }
      }
      return void 0;
    }
  };

  if (typeof module !== "undefined" && module !== null) {
    module.exports = models;
  }

}).call(this);