// Generated by CoffeeScript 1.6.3
(function() {
  var Image, ImagePadder, closest_power_of_two;

  closest_power_of_two = require('./utils/closest_power_of_two');

  Image = require('./image');

  ImagePadder = (function() {
    function ImagePadder(args) {
      var paddedHeight, paddedWidth;
      if (args == null) {
        args = {};
      }
      this.originalImage = args.image;
      this.paddedClass = args.type || this.default_padded_class();
      this.maxWidth = args.maxWidth || this.default_max_width();
      this.maxHeight = args.maxHeight || this.default_max_height();
      paddedWidth = args.paddedWidth || closest_power_of_two(this.originalImage.width, this.maxWidth);
      paddedHeight = args.paddedHeight || closest_power_of_two(this.originalImage.height, this.maxHeight);
      this.paddedImage = new this.paddedClass({
        width: paddedWidth,
        height: paddedHeight,
        dataType: this.originalImage.dataType
      });
    }

    ImagePadder.prototype.default_max_width = function() {
      return 512;
    };

    ImagePadder.prototype.default_max_height = function() {
      return 512;
    };

    ImagePadder.prototype.default_padded_class = function() {
      return Image;
    };

    ImagePadder.prototype.load = function() {
      var data, delta_h, delta_w, height, l, offset1, offset2, paddedData, paddedHeight, paddedWidth, width, x, y;
      data = this.originalImage.data;
      width = this.originalImage.width;
      height = this.originalImage.height;
      paddedData = this.paddedImage.data;
      paddedWidth = this.paddedImage.width;
      paddedHeight = this.paddedImage.height;
      l = paddedData.length;
      while (l--) {
        paddedData[l] = 0;
      }
      delta_h = Math.ceil((paddedHeight - height) / 2);
      delta_w = Math.ceil((paddedWidth - width) / 2);
      y = height;
      while (y--) {
        offset1 = y * width;
        offset2 = (y + delta_h) * paddedWidth + delta_w;
        x = width;
        while (x--) {
          paddedData[x + offset2] = data[x + offset1];
        }
      }
      return void 0;
    };

    ImagePadder.prototype.save = function() {
      var data, delta_h, delta_w, height, offset1, offset2, paddedData, paddedHeight, paddedWidth, width, x, y;
      data = this.originalImage.data;
      width = this.originalImage.width;
      height = this.originalImage.height;
      paddedData = this.paddedImage.data;
      paddedWidth = this.paddedImage.width;
      paddedHeight = this.paddedImage.height;
      delta_h = Math.ceil((paddedHeight - height) / 2);
      delta_w = Math.ceil((paddedWidth - width) / 2);
      y = height;
      while (y--) {
        offset1 = y * width;
        offset2 = (y + delta_h) * paddedWidth + delta_w;
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
