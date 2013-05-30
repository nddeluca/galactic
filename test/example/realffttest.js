var realfft = require('../../lib/math/realfftsplitradix');
var fftdif4 = require('../../lib/math/fftdif4');
var fftdit4 = require('../../lib/math/fftdit4');

var utils = require('../../lib/utils/arrayutils');

var n = 512*512;
var start;
var diff;


//--------------------------------
// Real Split-Radix
// ------------------------------

var buffer = new ArrayBuffer(8*2*n);
var x = new Float64Array(buffer)
var l = 2*Math.PI;
for( var i=0; i < n;i++){
  x[i] = Math.sin(i*(l/(n-1)));

}

for(var i=n; i < 2*n;i++){
  x[i]=0;
}


start = (new Date).getTime();
realfft.realfft(x,2*n);
diff = (new Date).getTime() - start;
console.log("Real Split-radix FFT Time: " + diff)

//-------------------------------
// DIF Radix-4
//-------------------------------
x = new Float64Array(buffer, 0,n);
y = new Float64Array(buffer,8*n);

for( var i=0; i < n;i++){
  x[i] = Math.sin(i*(l/(n-1)));
}

for(var i=0; i < n;i++){
  y[i]=0;
}

var ldn = Math.log(n)/Math.LN2

start = (new Date).getTime()

fftdif4(x,y,ldn);

diff  = (new Date).getTime() - start
console.log("Core DIF Radix-4 Time: " + diff);

start = (new Date).getTime()
utils.revbin_permute(x,n);
utils.revbin_permute(y,n);

diff = (new Date).getTime() - start
console.log("Permute Time: " + diff);

//-------------------------------
// DIT Radix-4
//-------------------------------
x = new Float64Array(buffer, 0,n);
y = new Float64Array(buffer,8*n);

for( var i=0; i < n;i++){
  x[i] = Math.sin(i*(l/(n-1)));
}

for(var i=0; i < n;i++){
  y[i]=0;
}

var ldn = Math.log(n)/Math.LN2


start = (new Date).getTime()
utils.revbin_permute(x,n);
utils.revbin_permute(y,n);

diff = (new Date).getTime() - start

console.log("Permute Time: " + diff);

start = (new Date).getTime()

fftdit4(x,y,ldn);

diff  = (new Date).getTime() - start
console.log("Core DIT Radix-4 Time: " + diff);

//--------------------------

//n = 8;
//x = []
//y = []

//for( var i=0; i < n;i++){
  //x[i] = Math.sin(i*(l/(n-1)));
//}

//for(var i=0; i < n;i++){
  //y[i]=0;
//}

//console.log("**********Original Values**********")
//console.log(x);
//console.log(y);

//var ldn = Math.log(n)/Math.LN2

//fftdif4(x,y,ldn);

//utils.revbin_permute(x,n)
//utils.revbin_permute(y,n)

//fftdit4(x,y,ldn)

//console.log("***********Values After Transform**********")

//console.log(x)
//console.log(y)

//fftdif4(y,x,ldn);

//utils.revbin_permute(x,n)
//utils.revbin_permute(y,n)

//fftdit4(y,x,ldn);

//for(var i=0; i <n;i++){
 //x[i] = (1/n)*x[i]
 //y[i] = (1/n)*y[i]

//}
//console.log("**********Values after FFT and Inverse**********")
//console.log(x)
//console.log(y)


