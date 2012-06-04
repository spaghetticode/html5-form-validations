# doesnt work yet
beforeEach ->
  @addMatchers
    toBeInstanceOf: (expected) ->
      @actual instanceof expected
