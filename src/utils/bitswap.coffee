# These functions are derived from the
# FXT Library (http://www.jjj.de/fxt/fxtpage.html)
# by Joerg Arndt
#
# Original copyright from fxt/bits/bitswap.h:
#
# This file is part of the FXT library.
# Copyright (C) 2010, 2012 Joerg Arndt
# License: GNU General Public License version 3 or later,
# see the file COPYING.txt in the main directory.

bitswap =
  swap1: (x) ->
    m = 0x55555555
    (((x & m) << 1) | ((x & (~m)) >>> 1)) >>> 0

  swap2: (x) ->
    m = 0x33333333
    (((x & m) << 2) | ((x & (~m)) >>> 2)) >>> 0

  swap4: (x) ->
    m = 0x0f0f0f0f
    (((x & m) << 4) | ((x & (~m)) >>> 4)) >>> 0

  swap8: (x) ->
    m = 0x00ff00ff
    (((x & m) << 8) | ((x & (~m)) >>> 8)) >>> 0

  swap16: (x) ->
    (((x << 16) | (x >>> 16))) >>> 0

module?.exports = bitswap

