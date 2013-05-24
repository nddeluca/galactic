var fft = require('../../lib/math/realfftsplitradix');

n = 16;

var x = [];

var l = 2*Math.PI;

for( var i=0; i < n;i++){
  x[i] = Math.sin(i*(l/(n-1)));

}

for(var i=n; i < 2*n;i++){
  x[i]=0;
}


var start = (new Date).getTime();
fft.realfft(x,2*n);
var diff = (new Date).getTime() - start;

console.log(x)

console.log(diff)
