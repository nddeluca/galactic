var fft_dif4_core = require('../../lib/math/fftdif4');
var fft_dit4_core = require('../../lib/math/fftdit4');

var Image = require('../../lib/image');
var ImagePadder = require('../../lib/image_padder');
var RowManipulator = require('../../lib/row_manipulator');
var ColumnManipulator = require('../../lib/column_manipulator');
var Sersic = require('../../lib/sersic');


n = 512
var model = new Sersic("Test",400,400)
ldn = Math.log(n)/Math.LN2


// Initialize variables and utilities
var padder = new ImagePadder({image: model, type: Image});
var iimg = new Image({ width: padder.paddedImage.width, height: padder.paddedImage.height, dataType: Float64Array});

var rowMan = new RowManipulator(padder.paddedImage);
var columnMan = new ColumnManipulator(padder.paddedImage);

var irowMan = new RowManipulator(iimg);
var icolumnMan = new ColumnManipulator(iimg);

var row = rowMan.row;
var irow = irowMan.row;
var column = columnMan.column;
var icolumn = icolumnMan.column;


var norm = 1/(n*n);

var rows = padder.paddedImage.width;
var columns = padder.paddedImage.height;
var plength = rows*columns;
var length = model.width*model.height;

var num = 100;
var iterations = num;

var start = (new Date).getTime()

while(iterations--)
{

// CALCULATE MODEL
model.build();

// LOAD MODEL INTO PADDED IMAGE
padder.load();

// CLEAR IMANIARY INPUT IMAGE
var i = plength
while(i--)
{
  iimg.data[i] = 0;
}

// FORWARD TRANSFROM
var r = rows;
while(r--)
{
  rowMan.load(r);
  irowMan.load(r);
  fft_dif4_core(row,irow,ldn)
  rowMan.save(r);
  irowMan.save(r);
}

var c = columns;
while(c--)
{
  columnMan.load(c)
  icolumnMan.load(c)
  fft_dif4_core(column,icolumn,ldn)
  columnMan.save(c)
  icolumnMan.save(c)
}


// INVERSE TRANSFORM
var r = rows;
while(r--)
{
  rowMan.load(r);
  irowMan.load(r);
  fft_dit4_core(irow,row,ldn)
  rowMan.save(r);
  irowMan.save(r);
}

var c = columns;
while(c--)
{
  columnMan.load(c)
  icolumnMan.load(c)
  fft_dit4_core(icolumn,column,ldn)
  columnMan.save(c)
  icolumnMan.save(c)
}

// SAVE THE DATA BACK TO MODEL
padder.save()

// NORMALIZE THE DATA
var l = length;
while(l--)
{
model.data[l] = model.data[l] * norm;
}




}

var diff = (new Date).getTime() - start

time = diff/num;

console.log("Average Time: " + time);
