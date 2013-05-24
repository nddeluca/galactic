var revbin = require('../lib/utils/bitreverse');
n = 16;
ldn = Math.log(n)/Math.LN2
for(i=0;i<n;i++) {
  console.log(i + ": " + revbin(i,ldn));
}
