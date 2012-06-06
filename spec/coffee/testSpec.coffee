require './helper'

describe 'Validations', ->
  Validations = window.Validations
  Field = window.Field
  field = null

  describe 'Validations', ->
    it 'is be defined', ->
      expect(Validations).toBeDefined()

    it 'has expected attributes', ->
      expect(Validations.emailRegexp).toBeDefined()
      expect(Validations.urlRegexp).toBeDefined()

    describe 'Validations.validateRequired()', ->
      beforeEach ->
        field = new Field('#name')

      it 'adds an error to field when has no value', ->
        spyOn(field, 'val').andReturn('')
        Validations.validateRequired(field)
        expect(field.errors).not.toBeEmpty()

      it 'adds no error when has value ', ->
        Validations.validateRequired(field)
        expect(field.errors).toBeEmpty()

    describe 'validatePattern()', ->
      beforeEach ->
        field = new Field('#age')

      it 'adds an error to field when value does not match', ->
        spyOn(field, 'val').andReturn('invalid!')
        Validations.validatePattern(field)
        expect(field.errors).not.toBeEmpty()

      it 'adds no error to field when value matches', ->
        Validations.validatePattern(field)
        expect(field.errors).toBeEmpty()


describe 'Field', ->
  Field = window.Field
  field = null

  beforeEach ->
    field = new Field('#email')

  # not working. The jquery wrapper doesnt work
  # via $('[data-errors]')
  # describe 'Field.messages()', ->
  #   it 'is an object', ->
  #     expect(Field.messages()).toBeDefined()

  #   it 'has expected value', ->
  #     message = 'cannot be blank'
  #     expect(Field.messages()['blank']).toEqual message

  describe 'a new Field instance', ->
    it 'is an instance of Field', ->
      expect(field).toBeInstanceOf Field

    it 'assings element', ->
      expect(field.element).toBeDefined()

    it 'has no error at start', ->
      expect(field.errors).toBeEmpty()

  describe 'val()', ->
    it 'delegates to the element val method', ->
      expect(field.element.val()).toEqual 'asd@asd.com'

  describe 'name()', ->
    it 'returns the element label text', ->
      text = $('label[for="email"]').text()
      expect(field.name()).toEqual text

  describe 'attr()', ->
    it 'delegates to the element attr method', ->

  describe 'addError()', ->
    it 'adds an item to @errors', ->
      field.addError('blank')
      expect(field.errors.length).toEqual 1

  describe 'isValid()', ->
    describe 'when validations are met', ->
      it 'is true', ->
        expect(field.isValid()).toBeTruthy()

  describe 'when validations are not met', ->
    it 'is false', ->
      spyOn(field, 'val').andReturn('invalid!')
      expect(field.isValid()).toBeFalsy()


describe 'Validator', ->
  Validator = window.Validator
  validator = null

  beforeEach ->
    validator = new Validator('form')

  describe 'a new Validator instance', ->
    it 'has no errors as start', ->
      expect(validator.errors).toBeEmpty()

    it 'assings element', ->
      expect(validator.element).toBeDefined()

    describe 'when the form fields have all valid values', ->
      it 'is will validate', ->
        expect(validator.isValid()).toBeTruthy()

      describe 'after validating the form', ->
        beforeEach ->
          validator.isValid()

      it 'still has no errors', ->
        expect(validator.errors).toBeEmpty()

      it 'has an empty error message', ->
        expect(validator.errorMessage()).toBeEmpty()

    describe 'when the form fields dont have all valid values', ->
      beforeEach ->
        label = $('<label for="surname">surname</label>')
        field = $('<input type="text" name="surname" required>')
        validator.element.append(label)
        validator.element.append(field)

      it 'will not validate', ->
        expect(validator.isValid()).toBeFalsy()

      describe 'after validating the form', ->
        beforeEach ->
          validator.isValid()

        it 'has errors', ->
          expect(validator.errors).not.toBeEmpty()

        it 'has a non empty error message', ->
          expect(validator.errorMessage()).not.toBeEmpty()
