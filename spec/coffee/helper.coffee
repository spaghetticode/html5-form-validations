fs    = require 'fs'
jsdom = require 'jsdom'
html  = fs.readFileSync './spec/fixtures/form.html', 'utf-8'
global.window = jsdom.jsdom(html).createWindow()
global.jQuery = global.$ = require 'jquery'

require '../../coffee/html5-form'
require './support/jasmine-extensions'
