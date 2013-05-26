var fft = require('../../lib/math/realfftsplitradix');

MAX = 10;
n = 1024*1024;

var start = (new Date).getTime()

var buffer = new ArrayBuffer(8*2*n);
var x = new Float64Array(buffer)
var l = 2*Math.PI;

for( var i=0; i < n;i++){
  x[i] = Math.sin(i*(l/(n-1)));

}

for(var i=n; i < 2*n;i++){
  x[i]=0;
}

var diff = (new Date).getTime() - start

console.log("Init Time: " + diff);

start = (new Date).getTime();
fft.realfft(x,2*n);
diff = (new Date).getTime() - start;

console.log("FFT Time: " + diff)
