;(function(e,t,n){function i(n,s){if(!t[n]){if(!e[n]){var o=typeof require=="function"&&require;if(!s&&o)return o(n,!0);if(r)return r(n,!0);throw new Error("Cannot find module '"+n+"'")}var u=t[n]={exports:{}};e[n][0].call(u.exports,function(t){var r=e[n][1][t];return i(r?r:t)},u,u.exports)}return t[n].exports}var r=typeof require=="function"&&require;for(var s=0;s<n.length;s++)i(n[s]);return i})({1:[function(require,module,exports){
var fft_dif4_core = require('../../lib/math/fftdif4');
var fft_dit4_core = require('../../lib/math/fftdit4');

var Image = require('../../lib/image');
var ImagePadder = require('../../lib/image_padder');
var RowManipulator = require('../../lib/row_manipulator');
var ColumnManipulator = require('../../lib/column_manipulator');
var Sersic = require('../../lib/sersic');


n = 512;
ldn = Math.log(n)/Math.LN2;

var model1 = new Sersic("Test",400,400);
var model2 = new Sersic("Test",400,400);

// Initialize variables and utilities
var padder1 = new ImagePadder({image: model1, type: Image});
var padder2 = new ImagePadder({image: model2, type: Image});


var iimg1 = new Image({ width: padder1.paddedImage.width, height: padder1.paddedImage.height, dataType: Float64Array});
var iimg2 = new Image({ width: padder1.paddedImage.width, height: padder1.paddedImage.height, dataType: Float64Array});

var rowMan1 = new RowManipulator(padder1.paddedImage);
var columnMan1 = new ColumnManipulator(padder1.paddedImage);
var irowMan1 = new RowManipulator(iimg1);
var icolumnMan1 = new ColumnManipulator(iimg1);

var row1 = rowMan1.row;
var irow1 = irowMan1.row;
var column1 = columnMan1.column;
var icolumn1 = icolumnMan1.column;


var rowMan2 = new RowManipulator(padder2.paddedImage);
var columnMan2 = new ColumnManipulator(padder2.paddedImage);
var irowMan2 = new RowManipulator(iimg2);
var icolumnMan2 = new ColumnManipulator(iimg2);

var row2 = rowMan2.row;
var irow2 = irowMan2.row;
var column2 = columnMan2.column;
var icolumn2 = icolumnMan2.column;
var norm = 1/(n*n);

var rows1 = padder1.paddedImage.width;
var columns1 = padder1.paddedImage.height;
var plength1 = rows1*columns1;
var length1 = model1.width*model1.height;

var rows2 = padder2.paddedImage.width;
var columns2 = padder2.paddedImage.height;
var plength2 = rows2*columns2;
var length1 = model2.width*model2.height;

var r1 = padder1.paddedImage.data;
var r2 = padder2.paddedImage.data;
var i1 = iimg1.data;
var i2 = iimg2.data;


var start;
var diff;

//PRE-COMPUTE MODEL 2 TO SIMULATE PSF

model2.build();
padder2.load();

var i = plength1;
while(i--)
{
iimg2.data[i] = 0;
}

var r = rows2;
while(r--)
{
  rowMan2.load(r);
  irowMan2.load(r);
  fft_dif4_core(row2,irow2,ldn);
  rowMan2.save(r);
  irowMan2.save(r);
}

var c = columns2;
while(c--)
{
  columnMan2.load(c)
  icolumnMan2.load(c)
  fft_dif4_core(column2,icolumn2,ldn);
  columnMan2.save(c)
  icolumnMan2.save(c)
}


//START TESTS
//
// CALCULATE MODEL
start = (new Date).getTime();

model1.build();

diff = (new Date).getTime() - start;
console.log("Time to Build Model: " + diff);

// LOAD MODEL INTO PADDED IMAGE
start = (new Date).getTime();

padder1.load();

diff = (new Date).getTime() - start;
console.log("Time to Pad the Image: " + diff);

// CLEAR IMANIARY INPUT IMAGE
start = (new Date).getTime();

var i = plength1;
while(i--)
{
  iimg1.data[i] = 0;
}

diff = (new Date).getTime() - start;
console.log("Time to Zero the Imaginary Components: " + diff);

// FORWARD TRANSFROM
start = (new Date).getTime();

r = rows1;
while(r--)
{
  rowMan1.load(r);
  irowMan1.load(r);
  fft_dif4_core(row1,irow1,ldn);
  rowMan1.save(r);
  irowMan1.save(r);
}

c = columns1;
while(c--)
{
  columnMan1.load(c)
  icolumnMan1.load(c)
  fft_dif4_core(column1,icolumn1,ldn);
  columnMan1.save(c)
  icolumnMan1.save(c)
}


diff = (new Date).getTime() - start;
console.log("Time for FFT: " + diff);

// MULTIPLY FOR CONVOLUTION
start = (new Date).getTime();

var l = plength1;
var a,b,c,d;
while(l--)
{
  a = r1[l];
  b = i1[l];
  c = r2[l];
  d = i2[l];

  r1[l] = a*c - b*d;
  i1[l] = a*d + b*c;
}

diff = (new Date).getTime() - start;
console.log("Time to Multiply Transforms: " + diff);

// INVERSE TRANSFORM
start = (new Date).getTime();

r = rows1;
while(r--)
{
  rowMan1.load(r);
  irowMan1.load(r);
  fft_dit4_core(irow1,row1,ldn);
  rowMan1.save(r);
  irowMan1.save(r);
}

c = columns1;
while(c--)
{
  columnMan1.load(c)
  icolumnMan1.load(c)
  fft_dit4_core(icolumn1,column1,ldn);
  columnMan1.save(c)
  icolumnMan1.save(c)
}

diff = (new Date).getTime() - start;
console.log("Time for Inverse FFT of Multiplication: " + diff);

// SAVE THE DATA BACK TO MODEL
start = (new Date).getTime();

padder1.save();

diff = (new Date).getTime() - start;
console.log("Time to Save Data back to Model: " + diff);

// NORMALIZE THE DATA
start = (new Date).getTime();

var l = length1;
while(l--)
{
model1.data[l] *= norm;
}

diff = (new Date).getTime() - start;
console.log("Time to Normalize Model: " + diff);








},{"../../lib/math/fftdif4":2,"../../lib/math/fftdit4":3,"../../lib/image":4,"../../lib/image_padder":5,"../../lib/row_manipulator":6,"../../lib/column_manipulator":7,"../../lib/sersic":8}],4:[function(require,module,exports){
// Generated by CoffeeScript 1.4.0
(function() {
  var Image;

  Image = (function() {

    function Image(args) {
      if (args == null) {
        args = {};
      }
      this.width = args.width || this.default_width();
      this.height = args.height || this.default_height();
      this.dataType = args.dataType || this.default_data_type();
      this.init_data_storage();
      this.post_initialize(args);
    }

    Image.prototype.post_initialize = function(args) {
      return null;
    };

    Image.prototype.init_data_storage = function() {
      this.buffer = new ArrayBuffer(this.width * this.height * this.dataType.BYTES_PER_ELEMENT);
      return this.data = new this.dataType(this.buffer);
    };

    Image.prototype.default_data_type = function() {
      return Float64Array;
    };

    Image.prototype.default_width = function() {
      return 512;
    };

    Image.prototype.default_height = function() {
      return 512;
    };

    return Image;

  })();

  if (typeof module !== "undefined" && module !== null) {
    module.exports = Image;
  }

}).call(this);

},{}],6:[function(require,module,exports){
// Generated by CoffeeScript 1.4.0
(function() {
  var RowManipulator;

  RowManipulator = (function() {

    function RowManipulator(image) {
      this.image = image;
      this.buffer = new ArrayBuffer(this.image.dataType.BYTES_PER_ELEMENT * this.image.width);
      this.row = new this.image.dataType(this.buffer);
    }

    RowManipulator.prototype.load = function(r) {
      var data, imageWidth, offset, row, x;
      row = this.row;
      data = this.image.data;
      imageWidth = this.image.width;
      offset = r * imageWidth;
      x = imageWidth;
      while (x--) {
        row[x] = data[x + offset];
      }
      return void 0;
    };

    RowManipulator.prototype.save = function(r) {
      var data, imageWidth, offset, row, x;
      row = this.row;
      data = this.image.data;
      imageWidth = this.image.width;
      offset = r * imageWidth;
      x = imageWidth;
      while (x--) {
        data[x + offset] = row[x];
      }
      return void 0;
    };

    return RowManipulator;

  })();

  if (typeof module !== "undefined" && module !== null) {
    module.exports = RowManipulator;
  }

}).call(this);

},{}],7:[function(require,module,exports){
// Generated by CoffeeScript 1.4.0
(function() {
  var ColumnManipulator;

  ColumnManipulator = (function() {

    function ColumnManipulator(image) {
      this.image = image;
      this.buffer = new ArrayBuffer(this.image.dataType.BYTES_PER_ELEMENT * this.image.height);
      this.column = new this.image.dataType(this.buffer);
    }

    ColumnManipulator.prototype.load = function(c) {
      var column, data, imageWidth, y;
      column = this.column;
      data = this.image.data;
      imageWidth = this.image.width;
      y = this.image.height;
      while (y--) {
        column[y] = data[c + y * imageWidth];
      }
      return void 0;
    };

    ColumnManipulator.prototype.save = function(c) {
      var column, data, imageWidth, y;
      column = this.column;
      data = this.image.data;
      imageWidth = this.image.width;
      y = this.image.height;
      while (y--) {
        data[c + y * imageWidth] = column[y];
      }
      return void 0;
    };

    return ColumnManipulator;

  })();

  if (typeof module !== "undefined" && module !== null) {
    module.exports = ColumnManipulator;
  }

}).call(this);

},{}],5:[function(require,module,exports){
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
    }

    ImagePadder.prototype.default_max_width = function() {
      return 512;
    };

    ImagePadder.prototype.default_max_height = function() {
      return 512;
    };

    ImagePadder.prototype.load = function() {
      var data, height, offset, offset1, offset2, paddedData, paddedHeight, paddedWidth, width, x, y;
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
      while (y--) {
        offset1 = y * width;
        offset2 = y * paddedWidth;
        x = width;
        while (x--) {
          paddedData[x + offset2] = data[x + offset1];
        }
      }
      return void 0;
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

},{"./utils/closest_power_of_two":9}],8:[function(require,module,exports){
// Generated by CoffeeScript 1.4.0
(function() {
  var Model, Sersic,
    __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  Model = require('./model');

  Sersic = (function(_super) {

    __extends(Sersic, _super);

    function Sersic(name, width, height) {
      this.name = name;
      this.width = width;
      this.height = height;
      Sersic.__super__.constructor.call(this, this.name, this.width, this.height);
      this.initDefaultParams();
      this.initParamArray();
    }

    Sersic.prototype.initParamArray = function() {
      return this.paramArray = ['centerX', 'centerY', 'angle', 'axisRatio', 'effRadius', 'intensity', 'n'];
    };

    Sersic.prototype.toJSON = function() {
      return JSON.stringify(this.params);
    };

    Sersic.prototype.initDefaultParams = function() {
      return this.params = {
        centerX: 31.5,
        centerY: 42,
        angle: 0,
        axisRatio: 1,
        effRadius: 6,
        intensity: 2.3,
        n: 1
      };
    };

    Sersic.prototype.build = function() {
      var angle, cos, cx, cy, data, exponent, height, intensity, invAxisRatio, invEffRadius, invN, n, norm, r, r_x, r_y, sin, width, x, y;
      Sersic.__super__.build.apply(this, arguments);
      data = this.data;
      n = this.params.n;
      invN = 1 / n;
      cx = this.params.centerX;
      cy = this.params.centerY;
      angle = this.params.angle;
      invAxisRatio = 1 / this.params.axisRatio;
      invEffRadius = 1 / this.params.effRadius;
      intensity = this.params.intensity;
      if (n === 4) {
        norm = 7.669;
      } else {
        norm = n * Math.exp(0.6950 - 0.1789 * invN);
      }
      sin = Math.sin(angle);
      cos = Math.cos(angle);
      width = this.width;
      height = this.height;
      x = width;
      while (x--) {
        y = height;
        while (y--) {
          r_x = (x - cx) * cos + (y - cy) * sin;
          r_y = ((y - cy) * cos - (x - cx) * sin) * invAxisRatio;
          r = Math.sqrt(r_x * r_x + r_y * r_y);
          exponent = norm * (Math.pow(r * invEffRadius, invN) - 1);
          data[y * width + x] = intensity * Math.exp(-exponent);
        }
      }
      return void 0;
    };

    return Sersic;

  })(Model);

  if (typeof module !== "undefined" && module !== null) {
    module.exports = Sersic;
  }

}).call(this);

},{"./model":10}],2:[function(require,module,exports){
// Generated by CoffeeScript 1.4.0
(function() {
  var fft8_dif_core, fft_dif4_core;

  fft8_dif_core = require('./fft8dif');

  fft_dif4_core = function(fr, fi, ldn) {
    var M_PI, c, c2, c3, cos, i0, i1, i2, i3, j, ldm, m, m4, n, ph, ph0, r, s, s2, s3, sin, st1, st2, t1, ui, ur, vi, vr, xi, xr, yi, yr;
    M_PI = Math.PI;
    sin = Math.sin;
    cos = Math.cos;
    n = 1 << ldn;
    if (n <= 2) {
      if (n === 2) {
        st1 = fr[0];
        st2 = fr[1];
        t1 = st1 - st2;
        fr[0] = st1 + st2;
        fr[1] = t1;
        st1 = fi[0];
        st2 = fi[1];
        t1 = st1 - st2;
        fr[0] = st1 + st2;
        fr[1] = t1;
      }
      return void 0;
    }
    ldm = ldn;
    while (ldm >= 4) {
      m = 1 << ldm;
      m4 = m >>> 2;
      ph0 = (2 * M_PI) / m;
      ph = 0;
      j = 0;
      while (j < m4) {
        s = sin(ph);
        c = cos(ph);
        ph += ph0;
        c2 = c * c - s * s;
        s2 = c * s;
        s2 += s2;
        c3 = c2 * c - s2 * s;
        s3 = s2 * c + c2 * s;
        r = 0;
        while (r < n) {
          i0 = j + r;
          i1 = i0 + m4;
          i2 = i1 + m4;
          i3 = i2 + m4;
          st1 = fr[i0];
          st2 = fr[i2];
          xr = st1 + st2;
          ur = st1 - st2;
          st1 = fi[i0];
          st2 = fi[i2];
          xi = st1 + st2;
          ui = st1 - st2;
          st1 = fr[i1];
          st2 = fr[i3];
          yr = st1 + st2;
          vi = st1 - st2;
          st1 = fi[i3];
          st2 = fi[i1];
          yi = st1 + st2;
          vr = st1 - st2;
          fr[i0] = xr + yr;
          yr = xr - yr;
          fi[i0] = xi + yi;
          yi = xi - yi;
          fr[i1] = yr * c2 - yi * s2;
          fi[i1] = yi * c2 + yr * s2;
          xr = ur + vr;
          yr = ur - vr;
          xi = ui + vi;
          yi = ui - vi;
          fr[i3] = yr * c3 - yi * s3;
          fi[i3] = yi * c3 + yr * s3;
          fr[i2] = xr * c - xi * s;
          fi[i2] = xi * c + xr * s;
          r += m;
        }
        j++;
      }
      ldm -= 2;
    }
    if ((ldn & 1) !== 0) {
      i0 = 0;
      while (i0 < n) {
        fft8_dif_core(fr, fi, i0);
        i0 += 8;
      }
    } else {
      i0 = 0;
      while (i0 < n) {
        i1 = i0 + 1;
        i2 = i1 + 1;
        i3 = i2 + 1;
        st1 = fr[i0];
        st2 = fr[i2];
        xr = st1 + st2;
        ur = st1 - st2;
        st1 = fr[i1];
        st2 = fr[i3];
        yr = st1 + st2;
        vi = st1 - st2;
        st1 = fi[i0];
        st2 = fi[i2];
        xi = st1 + st2;
        ui = st1 - st2;
        st1 = fi[i3];
        st2 = fi[i1];
        yi = st1 + st2;
        vr = st1 - st2;
        fi[i0] = xi + yi;
        fi[i1] = xi - yi;
        fi[i2] = ui + vi;
        fi[i3] = ui - vi;
        fr[i0] = xr + yr;
        fr[i1] = xr - yr;
        fr[i2] = ur + vr;
        fr[i3] = ur - vr;
        i0 += 4;
      }
    }
    return void 0;
  };

  if (typeof module !== "undefined" && module !== null) {
    module.exports = fft_dif4_core;
  }

}).call(this);

},{"./fft8dif":11}],3:[function(require,module,exports){
// Generated by CoffeeScript 1.4.0
(function() {
  var fft8_dit_core, fft_dit4_core;

  fft8_dit_core = require('./fft8dit');

  fft_dit4_core = function(fr, fi, ldn) {
    var M_PI, c, c2, c3, cos, i0, i1, i2, i3, j, ldm, m, m4, n, ph, ph0, r, s, s2, s3, sin, st1, st2, ui, ur, vi, vr, xi, xr, yi, yr;
    M_PI = Math.PI;
    sin = Math.sin;
    cos = Math.cos;
    n = 1 << ldn;
    if (n <= 2) {
      if (n === 2) {
        st1 = fr[0];
        st2 = fr[1];
        fr[0] = st1 + st2;
        fr[1] = st1 - st2;
        st1 = fi[0];
        st2 = fi[1];
        fi[0] = st1 + st2;
        fi[1] = st1 - st2;
      }
      return void 0;
    }
    ldm = ldn & 1;
    if (ldm !== 0) {
      i0 = 0;
      while (i0 < n) {
        fft8_dit_core(fr, fi, i0);
        i0 += 8;
      }
    } else {
      i0 = 0;
      while (i0 < n) {
        i1 = i0 + 1;
        i2 = i1 + 1;
        i3 = i2 + 1;
        st1 = fr[i0];
        st2 = fr[i1];
        xr = st1 + st2;
        ur = st1 - st2;
        st1 = fr[i2];
        st2 = fr[i3];
        yr = st1 + st2;
        vi = st1 - st2;
        st1 = fi[i0];
        st2 = fi[i1];
        xi = st1 + st2;
        ui = st1 - st2;
        st1 = fi[i3];
        st2 = fi[i2];
        yi = st1 + st2;
        vr = st1 - st2;
        fi[i1] = ui + vi;
        fi[i3] = ui - vi;
        fi[i0] = xi + yi;
        fi[i2] = xi - yi;
        fr[i1] = ur + vr;
        fr[i3] = ur - vr;
        fr[i0] = xr + yr;
        fr[i2] = xr - yr;
        i0 += 4;
      }
    }
    ldm += 4;
    while (ldm <= ldn) {
      m = 1 << ldm;
      m4 = m >>> 2;
      ph0 = (2 * M_PI) / m;
      ph = 0;
      j = 0;
      while (j < m4) {
        s = sin(ph);
        c = cos(ph);
        ph += ph0;
        c2 = c * c - s * s;
        s2 = c * s;
        s2 += s2;
        c3 = c2 * c - s2 * s;
        s3 = s2 * c + c2 * s;
        r = 0;
        while (r < n) {
          i0 = j + r;
          i1 = i0 + m4;
          i2 = i1 + m4;
          i3 = i2 + m4;
          st1 = fr[i1];
          st2 = fi[i1];
          xr = st1 * c2 - st2 * s2;
          xi = st2 * c2 + st1 * s2;
          st1 = fr[i0];
          ur = st1 - xr;
          xr = st1 + xr;
          st1 = fi[i0];
          ui = st1 - xi;
          xi = st1 + xi;
          st1 = fr[i2];
          st2 = fi[i2];
          yr = st1 * c - st2 * s;
          vr = st2 * c + st1 * s;
          st1 = fr[i3];
          st2 = fi[i3];
          vi = st1 * c3 - st2 * s3;
          yi = st2 * c3 + st1 * s3;
          st1 = yr - vi;
          yr = yr + vi;
          vi = st1;
          st1 = yi - vr;
          yi = yi + vr;
          vr = st1;
          fr[i1] = ur + vr;
          fr[i3] = ur - vr;
          fi[i1] = ui + vi;
          fi[i3] = ui - vi;
          fr[i0] = xr + yr;
          fr[i2] = xr - yr;
          fi[i0] = xi + yi;
          fi[i2] = xi - yi;
          r += m;
        }
        j++;
      }
      ldm += 2;
    }
    return void 0;
  };

  if (typeof module !== "undefined" && module !== null) {
    module.exports = fft_dit4_core;
  }

}).call(this);

},{"./fft8dit":12}],9:[function(require,module,exports){
// Generated by CoffeeScript 1.4.0
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

},{}],11:[function(require,module,exports){
// Generated by CoffeeScript 1.4.0
(function() {
  var fft8_dif_core;

  fft8_dif_core = function(fr, fi, offset) {
    var M_SQRT1_2, i0, i1, i2, i3, i4, i5, i6, i7, m0i, m0r, m1i, m1r, m2i, m2r, m3i, m3r, m4i, m4r, t1i, t1r, t2i, t2r, t3i, t3r, t4i, t4r, t5i, t5r, t6i, t6r, t7i, t7r, t8i, t8r;
    i0 = offset + 0;
    i1 = i0 + 1;
    i2 = i0 + 2;
    i3 = i0 + 3;
    i4 = i0 + 4;
    i5 = i0 + 5;
    i6 = i0 + 6;
    i7 = i0 + 7;
    M_SQRT1_2 = Math.SQRT1_2;
    t1r = fr[i0] + fr[i4];
    t2r = fr[i2] + fr[i6];
    t7r = t1r + t2r;
    t3r = fr[i1] - fr[i5];
    t4r = fr[i1] + fr[i5];
    t5r = fr[i3] + fr[i7];
    t8r = t4r + t5r;
    t6r = fr[i3] - fr[i7];
    m0r = t7r + t8r;
    m1r = t7r - t8r;
    m2r = t1r - t2r;
    m3r = fr[i0] - fr[i4];
    m4r = M_SQRT1_2 * (t3r - t6r);
    t8r = -(M_SQRT1_2 * (t3r + t6r));
    t6r = t5r - t4r;
    t7r = fr[i6] - fr[i2];
    t1i = fi[i0] + fi[i4];
    t2i = fi[i2] + fi[i6];
    t7i = t1i + t2i;
    t3i = fi[i1] - fi[i5];
    t4i = fi[i1] + fi[i5];
    t5i = fi[i3] + fi[i7];
    t8i = t4i + t5i;
    t6i = fi[i3] - fi[i7];
    m0i = t7i + t8i;
    m1i = t7i - t8i;
    m2i = t1i - t2i;
    m3i = fi[i0] - fi[i4];
    m4i = M_SQRT1_2 * (t3i - t6i);
    t8i = M_SQRT1_2 * (t3i + t6i);
    t6i = t4i - t5i;
    t7i = fi[i2] - fi[i6];
    t1r = m3r + m4r;
    t2r = m3r - m4r;
    t3r = t7i + t8i;
    t4r = t7i - t8i;
    fr[i0] = m0r;
    fr[i7] = t1r + t3r;
    fr[i3] = m2r + t6i;
    fr[i5] = t2r - t4r;
    fr[i1] = m1r;
    fr[i6] = t2r + t4r;
    fr[i2] = m2r - t6i;
    fr[i4] = t1r - t3r;
    t1r = m3i + m4i;
    t2r = m3i - m4i;
    t3r = t7r + t8r;
    t4r = t7r - t8r;
    fi[i0] = m0i;
    fi[i7] = t1r + t3r;
    fi[i3] = m2i + t6r;
    fi[i5] = t2r - t4r;
    fi[i1] = m1i;
    fi[i6] = t2r + t4r;
    fi[i2] = m2i - t6r;
    fi[i4] = t1r - t3r;
    return void 0;
  };

  if (typeof module !== "undefined" && module !== null) {
    module.exports = fft8_dif_core;
  }

}).call(this);

},{}],12:[function(require,module,exports){
// Generated by CoffeeScript 1.4.0
(function() {
  var fft8_dit_core;

  fft8_dit_core = function(fr, fi, offset) {
    var M_SQRT1_2, i0, i1, i2, i3, i4, i5, i6, i7, m0i, m0r, m1i, m1r, m2i, m2r, m3i, m3r, m4i, m4r, t1i, t1r, t2i, t2r, t3i, t3r, t4i, t4r, t5i, t5r, t6i, t6r, t7i, t7r, t8i, t8r;
    i0 = 0 + offset;
    i1 = i0 + 1;
    i2 = i0 + 2;
    i3 = i0 + 3;
    i4 = i0 + 4;
    i5 = i0 + 5;
    i6 = i0 + 6;
    i7 = i0 + 7;
    M_SQRT1_2 = Math.SQRT1_2;
    t1r = fr[i0] + fr[i1];
    t2r = fr[i2] + fr[i3];
    t7r = t1r + t2r;
    t3r = fr[i4] - fr[i5];
    t4r = fr[i4] + fr[i5];
    t5r = fr[i6] + fr[i7];
    t8r = t4r + t5r;
    t6r = fr[i6] - fr[i7];
    m0r = t7r + t8r;
    m1r = t7r - t8r;
    m2r = t1r - t2r;
    m3r = fr[i0] - fr[i1];
    m4r = M_SQRT1_2 * (t3r - t6r);
    t8r = M_SQRT1_2 * (t3r + t6r);
    t6r = t5r - t4r;
    t7r = fr[i3] - fr[i2];
    t1i = fi[i0] + fi[i1];
    t2i = fi[i2] + fi[i3];
    t7i = t1i + t2i;
    t3i = fi[i4] - fi[i5];
    t4i = fi[i4] + fi[i5];
    t5i = fi[i6] + fi[i7];
    t8i = t4i + t5i;
    t6i = fi[i6] - fi[i7];
    m0i = t7i + t8i;
    m1i = t7i - t8i;
    m2i = t1i - t2i;
    m3i = fi[i0] - fi[i1];
    m4i = M_SQRT1_2 * (t3i - t6i);
    t8i = M_SQRT1_2 * (t3i + t6i);
    t6i = t4i - t5i;
    t7i = fi[i2] - fi[i3];
    t1r = m3r + m4r;
    t2r = m3r - m4r;
    t3r = t7i + t8i;
    t4r = t7i - t8i;
    fr[i0] = m0r;
    fr[i7] = t1r + t3r;
    fr[i6] = m2r + t6i;
    fr[i5] = t2r - t4r;
    fr[i4] = m1r;
    fr[i3] = t2r + t4r;
    fr[i2] = m2r - t6i;
    fr[i1] = t1r - t3r;
    t1r = m3i + m4i;
    t2r = m3i - m4i;
    t3r = t7r - t8r;
    t4r = t7r + t8r;
    fi[i0] = m0i;
    fi[i7] = t1r + t3r;
    fi[i6] = m2i + t6r;
    fi[i5] = t2r - t4r;
    fi[i4] = m1i;
    fi[i3] = t2r + t4r;
    fi[i2] = m2i - t6r;
    fi[i1] = t1r - t3r;
    return void 0;
  };

  if (typeof module !== "undefined" && module !== null) {
    module.exports = fft8_dit_core;
  }

}).call(this);

},{}],10:[function(require,module,exports){
// Generated by CoffeeScript 1.4.0
(function() {
  var Image, Model,
    __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  Image = require('./image');

  Model = (function(_super) {

    __extends(Model, _super);

    function Model(name, width, height) {
      this.name = name;
      this.width = width;
      this.height = height;
      Model.__super__.constructor.call(this, {
        width: this.width,
        height: this.height,
        dataType: Float64Array
      });
      this.enabled = true;
      this.stale = true;
      this.params = {};
      this.paramArray = [];
    }

    Model.prototype.enable = function() {
      return this.enabled = true;
    };

    Model.prototype.disable = function() {
      return this.enabled = false;
    };

    Model.prototype.updateParams = function(params) {
      this.params = params;
      return this.stale = true;
    };

    Model.prototype.build = function() {
      return this.stale = false;
    };

    return Model;

  })(Image);

  if (typeof module !== "undefined" && module !== null) {
    module.exports = Model;
  }

}).call(this);

},{"./image":4}]},{},[1])
;