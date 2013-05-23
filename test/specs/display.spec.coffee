require('../spec_helper')
jsdom = require('jsdom')

Display = require('../../src/display')

describe 'Display', ->
  display = null

  beforeEach ->
    jsdom.env

