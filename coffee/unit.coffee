
class Unit
  isFirst: ->
    return false unless @parent?
    @parent.len() > 0 and @index is 0

  isLast: ->
    return false unless @parent?
    (@parent.len() - 1) is @index and @index > 0

exports.Unit = Unit