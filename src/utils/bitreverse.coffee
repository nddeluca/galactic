# This function is derived from the
# FXT Library (http://www.jjj.de/fxt/fxtpage.html)
# by Joerg Arndt
#
# Original copyright from fxt/bits/revbin.h:
#
# This file is part of the FXT library.
# Copyright (C) 2010, 2012, 2013 Joerg Arndt
# License: GNU General Public License version 3 or later,
# see the file COPYING.txt in the main directory.

bitswap = require('./bitswap')

revbin = (x, ldn) ->
  x = bitswap.swap1(x)
  x = bitswap.swap2(x)
  x = bitswap.swap4(x)
  x = bitswap.swap8(x)
  x = bitswap.swap16(x)
  x >>> (32-ldn)

module?.exports = revbin
