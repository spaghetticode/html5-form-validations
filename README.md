# html5 form validations

This library aims to be a simple way to add some kind of client-side
validations to form elements.

It uses the html5 validations syntax, which means that if the browser if html5
validations capable this library will do basically nothing, otherwise it will
handle validations.

At the moment it supports the following html5 validations: required, pattern,
email, url. More can be added easily, but I am not needing them right now.

You can customize the behaviour when errors are found by the library extending
Validator.manageErorrs() method. By default it just alerts the user with a list
of errors, which is not that nice ;-)


# Install

Run in terminal:
```bash
  npm install html5-form-validations
```


# Tests

Run in terminal:
```bash
  npm test
```


# Usage

See example.html for a basic use case.
