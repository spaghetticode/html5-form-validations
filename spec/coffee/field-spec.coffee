Field = require '../../html5-form'

jsdom = require('jsdom').jsdom
myWindow = jsdom().createWindow()
$ = require('jQuery')
jq = require('jQuery').create()
jQuery = require('jQuery').create(myWindow)

describe 'Field', ->
  field = null

  beforeEach ->
    # this should be loaded from the helpers directory
    @addMatchers
      toBeInstanceOf: (expected) ->
        @actual instanceof expected
      toBeEmpty: (expected) ->
        @actual.length == 0

  beforeEach ->
    $('body').append('<input name="something" value="42"></input>')
    field = new Field('[name="something"]')

  it 'is an istance of Field', ->
    expect(field).toBeInstanceOf Field

  it 'is an istance of Field', ->
    expect(field.element.length).toEqual 1

  it 'has no errors at start', ->
    expect(field.errors).toBeEmpty()

  it 'has element', ->
    expect(field.element).toBeDefined()

  # describe '#val', ->
  #   it 'delegates to @element', ->
  #     expect(field.element.attr('value')).toEqual '42'
