// Generated by CoffeeScript 1.4.0
(function() {
  var ImagePadder, closest_power_of_two;

  closest_power_of_two = require('./utils/closest_power_of_two');

  ImagePadder = (function() {

    function ImagePadder(args) {
      var paddedHeight, paddedWidth;
      if (args == null) {
        args = {};
      }
      this.image = args.image;
      this.paddedClass = args.type;
      this.maxWidth = args.maxWidth || this.default_max_width();
      this.maxHeight = args.maxHeight || this.default_max_height();
      paddedWidth = closest_power_of_two(this.image.width, this.maxWidth);
      paddedHeight = closest_power_of_two(this.image.height, this.maxHeight);
      this.paddedImage = new this.paddedClass({
        width: paddedWidth,
        height: paddedHeight,
        dataType: this.image.dataType
      });
      this.load();
    }

    ImagePadder.prototype.default_max_width = function() {
      return 512;
    };

    ImagePadder.prototype.default_max_height = function() {
      return 512;
    };

    ImagePadder.prototype.load = function() {
      var data, height, offset, offset1, offset2, paddedData, paddedHeight, paddedWidth, width, x, y, _results;
      data = this.image.data;
      width = this.image.width;
      height = this.image.height;
      paddedData = this.paddedImage.data;
      paddedWidth = this.paddedImage.width;
      paddedHeight = this.paddedImage.height;
      y = paddedHeight - 1;
      while (y >= height) {
        offset = y * paddedWidth;
        x = paddedWidth - 1;
        while (x >= width) {
          paddedData[x + offset] = 0;
          x--;
        }
        y--;
      }
      y = height;
      _results = [];
      while (y--) {
        offset1 = y * width;
        offset2 = y * paddedWidth;
        x = width;
        _results.push((function() {
          var _results1;
          _results1 = [];
          while (x--) {
            _results1.push(paddedData[x + offset2] = data[x + offset1]);
          }
          return _results1;
        })());
      }
      return _results;
    };

    ImagePadder.prototype.save = function() {
      var data, height, offset1, offset2, paddedData, paddedHeight, paddedWidth, width, x, y;
      data = this.image.data;
      width = this.image.width;
      height = this.image.height;
      paddedData = this.paddedImage.data;
      paddedWidth = this.paddedImage.width;
      paddedHeight = this.paddedImage.height;
      y = height;
      while (y--) {
        offset1 = y * width;
        offset2 = y * paddedWidth;
        x = width;
        while (x--) {
          data[x + offset1] = paddedData[x + offset2];
        }
      }
      return void 0;
    };

    return ImagePadder;

  })();

  if (typeof module !== "undefined" && module !== null) {
    module.exports = ImagePadder;
  }

}).call(this);