
class Unit

  is: (name) ->
    method =
      empty: => @getLength() is 0
      short: => @getLength() is 1
      long: => @getLength() > 1
      nested: =>
        return no if method.empty()
        @list.some (item) -> item.isExp
      plain: => not method.nested()
      first: => @parent.getLength() > 0 and @index is 0
      last: => @index is (@parent.getLength() - 1)
      exp: => not @isToken
      token: => @isToken
      block: => @caret.state is 'block'
      word: => @caret.state is 'word'
      indented: => @parent.indented
      align: => not @parent.indented
      far: => @index > 2
      crowded: => @parent.crowded

    for key in name.split(' ')
      return no unless method[key]()
    return yes

exports.Unit = Unit