# This the class that holds all available validations for your form fields.
# Error messages must be provided in the html, see Field class
class Validations
  @emailRegexp = /^(?:[\w\!\#\$\%\&\'\*\+\-\/\=\?\^\`\{\|\}\~]+\.)*[\w\!\#\$\%\&\'\*\+\-\/\=\?\^\`\{\|\}\~]+@(?:(?:(?:[a-zA-Z0-9](?:[a-zA-Z0-9\-](?!\.)){0,61}[a-zA-Z0-9]?\.)+[a-zA-Z0-9](?:[a-zA-Z0-9\-](?!$)){0,61}[a-zA-Z0-9]?)|(?:\[(?:(?:[01]?\d{1,2}|2[0-4]\d|25[0-5])\.){3}(?:[01]?\d{1,2}|2[0-4]\d|25[0-5])\]))$/
  @urlRegexp   = /^(?:(?:ht|f)tp(?:s?)\:\/\/|~\/|\/)?(?:\w+:\w+@)?((?:(?:[-\w\d{1-3}]+\.)+(?:com|org|net|gov|mil|biz|info|mobi|name|aero|jobs|edu|co\.uk|ac\.uk|it|fr|tv|museum|asia|local|travel|[a-z]{2}))|((\b25[0-5]\b|\b[2][0-4][0-9]\b|\b[0-1]?[0-9]?[0-9]\b)(\.(\b25[0-5]\b|\b[2][0-4][0-9]\b|\b[0-1]?[0-9]?[0-9]\b)){3}))(?::[\d]{1,5})?(?:(?:(?:\/(?:[-\w~!$+|.,=]|%[a-f\d]{2})+)+|\/)+|\?|#)?(?:(?:\?(?:[-\w~!$+|.,*:]|%[a-f\d{2}])+=?(?:[-\w~!$+|.,*:=]|%[a-f\d]{2})*)(?:&(?:[-\w~!$+|.,*:]|%[a-f\d{2}])+=?(?:[-\w~!$+|.,*:=]|%[a-f\d]{2})*)*)*(?:#(?:[-\w~!$ |\/.,*:;=]|%[a-f\d]{2})*)?$/

  # checks that the element has a non empty value
  @validateRequired = (element) ->
    if element.attr('required')
      if element.attr('type') == 'radio'
        @validateRadio(element)
      else
        element.addError('blank') if /^\s*$/.test(element.val()) or !element.val()

  # checks that the element value matches a regexp
  @validatePattern = (element) ->
    if value = element.val()
      if regex = element.attr('pattern')
        element.addError('invalid') unless new RegExp(regex).test(value)

  # checks that a terms and conditions checkbox is checked
  @validateAccepted = (element) ->
    if element.attr('accepted')
      element.addError('accepted') unless element.attr('checked')

  # checks that the radio group has 1 element checked
  @validateRadio = (element) ->
      name = element.attr('name')
      checked = $("[name='#{name}']").map -> $(this).attr('checked')
      element.addError('blank') unless checked.length

  # checks the value is an email
  @validateEmail = (element) ->
    if value = element.val()
      if element.attr('type')  == 'email'
        name = element.attr('name')
        element.addError('invalid') unless Validations.emailRegexp.test(value)

  # checks that the value is a url
  @validateUrl = (element) ->
    if value = element.val()
      if element.attr('type')  == 'url'
        name = element.attr('name')
        element.addError('invalid') unless Validations.urlRegexp.test(value)

window.Validations = Validations




# Each form input, select, textarea is instantiated as FormField to be checked
# for invalid values. Error messages are read from the tag that has "data-error"
# attribute.
class Field
  @messages = (message) ->
    @_messages or= $('[data-errros]').data('errors')
    if message then @_messages[message] else @_messages

  constructor: (element) ->
    @errors  = []
    @element = $(element)

  isValid: ->
    @errors = []
    @validate()
    if @errors.length then false else true

  validate: ->
    Validations.validatePattern(@)
    Validations.validateRequired(@)
    Validations.validateAccepted(@)
    Validations.validateEmail(@)
    Validations.validateUrl(@)

  addError: (message) -> @errors.push Field.messages(message)

  attr: (attribute) -> @element.attr(attribute)

  name: -> @element.prev('label').text()

  val: -> @element.val()

window.Field = Field




# Actual form validator class. It will pass to validations all the input,
# select, textarea tags inside the form element. In order to customize your
# ouput format you can override Validator.manageErorrs().
class Validator
  @validate = (form) ->
    validator = new @(form)
    if validator.isValid()
      true
    else
      @manageErorrs(validator)
      false

  @manageErorrs = (validator) ->
    alert validator.errorMessage()

  constructor: (element) ->
    @errors  = {}
    @element = $(element)

  isValid: ->
    @errors = {}
    for element in @element.find('input, select, textarea')
      formField = new Field(element)
      unless formField.isValid()
        @errors[formField.name()] = formField.errors
    $.isEmptyObject(@errors)

  errorMessage: ->
    message = ''
    for name, errors of @errors
      message += "#{name} #{errors.join ', '}\n"
    message

window.Validator = Validator
