var fft_dif4_core = require('../../lib/math/fftdif4');
var fft_dit4_core = require('../../lib/math/fftdit4');

var Image = require('../../lib/image');
var ImagePadder = require('../../lib/image_padder');
var RowManipulator = require('../../lib/row_manipulator');
var ColumnManipulator = require('../../lib/column_manipulator');
var Sersic = require('../../lib/sersic');

var arrayutils = require('../../lib/utils/arrayutils');
var permute = arrayutils.revbin_permute;
var start = (new Date).getTime()

n = 512
var model = new Sersic("Test",400,400)
ldn = Math.log(n)/Math.LN2
//------------------------------
start = (new Date).getTime()

model.build();

diff = (new Date).getTime() - start
console.log("Time to build Model: " + diff)

//model.data[0] = 1
//model.data[1] = 2
//model.data[2] = 3
//model.data[3] = 4
//model.data[4] = 5
//model.data[5] = 6
//model.data[6] = 7
//model.data[7] = 8
//model.data[8] = 8
//model.data[9] = 7
//model.data[10] = 6
//model.data[11] = 5
//model.data[12] = 4
//model.data[13] = 3
//model.data[14] = 2
//model.data[15] = 1

omax = arrayutils.max(model.data)
//---------------------------

padder = new ImagePadder({image: model, type: Image});

//-----------------------------
start = (new Date).getTime()

padder.load()

var diff = (new Date).getTime() - start
console.log("Time To Pad Image: " + diff)
//-------------------------------


//--------------------------------
// Build Imaginary Image Buffer
//------------------------------

var iimg = new Image({ width: padder.paddedImage.width, height: padder.paddedImage.height, dataType: Float64Array})

for(var i = 0; i < iimg.width; i++){
  for(var j = 0; j< iimg.height; j++){
    iimg[i + j*iimg.width] = 0;
  }
}


rowMan = new RowManipulator(padder.paddedImage)
columnMan = new ColumnManipulator(padder.paddedImage)

irowMan = new RowManipulator(iimg)
icolumnMan = new ColumnManipulator(iimg)

var rows = padder.paddedImage.width
var columns = padder.paddedImage.height

start = (new Date).getTime()


for(var r = 0; r < rows; r++) {
  rowMan.load(r);
  irowMan.load(r);
  fft_dif4_core(rowMan.row,irowMan.row,ldn)
  //permute(rowMan.row)
  //permute(irowMan.row)
  rowMan.save(r);
  irowMan.save(r);
}


for(var c = 0; c < columns; c++) {
  columnMan.load(c)
  icolumnMan.load(c)
  fft_dif4_core(columnMan.column,icolumnMan.column,ldn)
  //permute(rowMan.row)
  //permute(irowMan.row)
  columnMan.save(c)
  icolumnMan.save(c)
}



diff = (new Date).getTime() - start
console.log("Time for 2D FFT: " + diff)

//-------------------------------

start = (new Date).getTime()

for(var r = 0; r < rows; r++) {
  rowMan.load(r);
  irowMan.load(r);
  //permute(columnMan.column)
  //permute(icolumnMan.column)
  fft_dit4_core(irowMan.row,rowMan.row,ldn)
  rowMan.save(r);
  irowMan.save(r);
}

for(var c = 0; c < columns; c++) {
  columnMan.load(c)
  icolumnMan.load(c)
  //permute(columnMan.column)
  //permute(icolumnMan.column)
  fft_dit4_core(icolumnMan.column,columnMan.column,ldn)
  columnMan.save(c)
  icolumnMan.save(c)
}

diff = (new Date).getTime() - start
console.log("Time for Inverse 2D FFT: " + diff)
//--------------------------------
//
//

//---------------------------------

start = (new Date).getTime()
padder.save()
diff = (new Date).getTime() - start
console.log("Time to save back to model: " + diff)


length = model.width*model.height
for(var k = 0; k < length; k++) {
model.data[k] = model.data[k] * (1/(n*n))
}

nmax = arrayutils.max(model.data);

console.log(omax)
console.log(nmax)


console.log("Eror in inf norm: " + Math.abs(omax-nmax))

