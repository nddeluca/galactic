var fft_dif4_core = require('../../lib/math/fftdif4');
var fft_dit4_core = require('../../lib/math/fftdit4');

var Image = require('../../lib/image');
var ImagePadder = require('../../lib/image_padder');
var RowManipulator = require('../../lib/row_manipulator');
var ColumnManipulator = require('../../lib/column_manipulator');
var Sersic = require('../../lib/sersic');


n = 512;
ldn = Math.log(n)/Math.LN2;

var model1 = new Sersic({name: "Test", width: 400, height: 400});
var model2 = new Sersic({name: "Test", width: 400, height: 400});

// Initialize variables and utilities
var padder1 = new ImagePadder({image: model1, type: Image});
var padder2 = new ImagePadder({image: model2, type: Image});


var iimg1 = new Image({ width: padder1.paddedImage.width, height: padder1.paddedImage.height, dataType: Float64Array});
var iimg2 = new Image({ width: padder1.paddedImage.width, height: padder1.paddedImage.height, dataType: Float64Array});

var rowMan1 = new RowManipulator({image: padder1.paddedImage});
var columnMan1 = new ColumnManipulator({image: padder1.paddedImage});
var irowMan1 = new RowManipulator({image: iimg1});
var icolumnMan1 = new ColumnManipulator({image: iimg1});

var row1 = rowMan1.row;
var irow1 = irowMan1.row;
var column1 = columnMan1.column;
var icolumn1 = icolumnMan1.column;


var rowMan2 = new RowManipulator({image: padder2.paddedImage});
var columnMan2 = new ColumnManipulator({image: padder2.paddedImage});
var irowMan2 = new RowManipulator({image: iimg2});
var icolumnMan2 = new ColumnManipulator({image: iimg2});

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







