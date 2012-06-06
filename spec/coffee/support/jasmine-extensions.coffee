jasmine.Matchers::toBeInstanceOf = (expected) ->
  @actual instanceof expected

jasmine.Matchers::toBeEmpty = ->
  @actual.length == 0 or $.isEmptyObject(@actual)

