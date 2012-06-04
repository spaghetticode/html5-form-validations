(function() {

  window.Validations = (function() {

    function Validations() {}

    Validations.emailRegexp = /^(?:[\w\!\#\$\%\&\'\*\+\-\/\=\?\^\`\{\|\}\~]+\.)*[\w\!\#\$\%\&\'\*\+\-\/\=\?\^\`\{\|\}\~]+@(?:(?:(?:[a-zA-Z0-9](?:[a-zA-Z0-9\-](?!\.)){0,61}[a-zA-Z0-9]?\.)+[a-zA-Z0-9](?:[a-zA-Z0-9\-](?!$)){0,61}[a-zA-Z0-9]?)|(?:\[(?:(?:[01]?\d{1,2}|2[0-4]\d|25[0-5])\.){3}(?:[01]?\d{1,2}|2[0-4]\d|25[0-5])\]))$/;

    Validations.urlRegexp = /^(?:(?:ht|f)tp(?:s?)\:\/\/|~\/|\/)?(?:\w+:\w+@)?((?:(?:[-\w\d{1-3}]+\.)+(?:com|org|net|gov|mil|biz|info|mobi|name|aero|jobs|edu|co\.uk|ac\.uk|it|fr|tv|museum|asia|local|travel|[a-z]{2}))|((\b25[0-5]\b|\b[2][0-4][0-9]\b|\b[0-1]?[0-9]?[0-9]\b)(\.(\b25[0-5]\b|\b[2][0-4][0-9]\b|\b[0-1]?[0-9]?[0-9]\b)){3}))(?::[\d]{1,5})?(?:(?:(?:\/(?:[-\w~!$+|.,=]|%[a-f\d]{2})+)+|\/)+|\?|#)?(?:(?:\?(?:[-\w~!$+|.,*:]|%[a-f\d{2}])+=?(?:[-\w~!$+|.,*:=]|%[a-f\d]{2})*)(?:&(?:[-\w~!$+|.,*:]|%[a-f\d{2}])+=?(?:[-\w~!$+|.,*:=]|%[a-f\d]{2})*)*)*(?:#(?:[-\w~!$ |\/.,*:;=]|%[a-f\d]{2})*)?$/;

    Validations.validateRequired = function(element) {
      if (element.attr('required')) {
        if (element.attr('type') === 'radio') {
          return this.validateRadio(element);
        } else {
          if (/^\s*$/.test(element.val())) return element.addError('blank');
        }
      }
    };

    Validations.validatePattern = function(element) {
      var regex, value;
      if (value = element.val()) {
        if (regex = element.attr('pattern')) {
          if (!new RegExp(regex).test(value)) return element.addError('invalid');
        }
      }
    };

    Validations.validateAccepted = function(element) {
      if (element.attr('accepted')) {
        if (!element.attr('checked')) return element.addError('accepted');
      }
    };

    Validations.validateRadio = function(element) {
      var checked, name;
      name = element.attr('name');
      checked = $("[name='" + name + "']").map(function() {
        return $(this).attr('checked');
      });
      if (!checked.length) return element.addError('blank');
    };

    Validations.validateEmail = function(element) {
      var name, value;
      if (value = element.val()) {
        if (element.attr('type') === 'email') {
          name = element.attr('name');
          if (!Validations.emailRegexp.test(value)) {
            return element.addError('invalid');
          }
        }
      }
    };

    Validations.validateUrl = function(element) {
      var name, value;
      if (value = element.val()) {
        if (element.attr('type') === 'url') {
          name = element.attr('name');
          if (!Validations.urlRegexp.test(value)) {
            return element.addError('invalid');
          }
        }
      }
    };

    return Validations;

  })();

  window.Field = (function() {

    Field.messages = function(message) {
      this._messages || (this._messages = $('[data-errors]').data('errors'));
      if (message) {
        return this._messages[message];
      } else {
        return this._messages;
      }
    };

    function Field(element) {
      this.errors = [];
      this.element = $(element);
    }

    Field.prototype.isValid = function() {
      this.errors = [];
      this.validate();
      if (this.errors.length) {
        return false;
      } else {
        return true;
      }
    };

    Field.prototype.validate = function() {
      Validations.validatePattern(this);
      Validations.validateRequired(this);
      Validations.validateAccepted(this);
      Validations.validateEmail(this);
      return Validations.validateUrl(this);
    };

    Field.prototype.addError = function(message) {
      return this.errors.push(Field.messages(message));
    };

    Field.prototype.attr = function(attribute) {
      return this.element.attr(attribute);
    };

    Field.prototype.name = function() {
      return this.element.prev('label').text();
    };

    Field.prototype.val = function() {
      return this.element.val();
    };

    return Field;

  })();

  window.Validator = (function() {

    Validator.validate = function(form) {
      var validator;
      validator = new Validator(form);
      if (validator.isValid()) {
        return true;
      } else {
        alert(validator.errorMessages());
        return false;
      }
    };

    function Validator(element) {
      this.errors = {};
      this.element = $(element);
    }

    Validator.prototype.isValid = function() {
      var element, formField, _i, _len, _ref;
      this.errors = {};
      _ref = this.element.find('input, select, textarea');
      for (_i = 0, _len = _ref.length; _i < _len; _i++) {
        element = _ref[_i];
        formField = new Field(element);
        if (!formField.isValid()) this.errors[formField.name()] = formField.errors;
      }
      return $.isEmptyObject(this.errors);
    };

    Validator.prototype.errorMessages = function() {
      var errors, message, name, _ref;
      message = '';
      _ref = this.errors;
      for (name in _ref) {
        errors = _ref[name];
        message += "" + name + " " + (errors.join(', ')) + "\n";
      }
      return message;
    };

    return Validator;

  })();

}).call(this);
