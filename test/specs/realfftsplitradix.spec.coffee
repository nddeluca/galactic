fft = require('../../src/math/realfftsplitradix')

describe 'fft', ->
  it 'should give correct result for simple example', ->
    n = 16
    buffer = new ArrayBuffer(4*2*n)
    x = new Float32Array(buffer)
    x = []
    l = 2*Math.PI
    for i in [0..n-1]
      x[i] = Math.sin(i*(l/(n-1)))
    for i in [n..2*n-1]
      x[i] = 0

    fft.realfft(x,2*n)
    result = [-2.498001805406602e-16,1.498004601724786,-0.28853702863477154,-0.23648825540274937,-0.22261434265426738,-0.21693237284402905,-0.2142171111469861,-0.2129372102069711,-0.2125565616700222,-0.2129372102069711,-0.2142171111469861,-0.21693237284402905,-0.22261434265426738,-0.23648825540274937,-0.28853702863477154,1.498004601724786,-2.498001805406602e-16,7.530977693637282,-0.6965900077769002,-0.35392968583846285,-0.22261434265426847,-0.1449495774075249,-0.08873163272946705,-0.042355844585489244,0,0.042355844585489244,0.08873163272946705,0.1449495774075249,0.22261434265426847,0.35392968583846285,0.6965900077769002,-7.530977693637282 ]
    expect(x).toEqual result

