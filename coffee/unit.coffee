
class Unit

  is: (name) ->
    method =
      empty: => @len() is 0
      short: => @len() is 1
      long: => @len() > 1
      nested: =>
        return no if method.empty()
        @list.some (item) -> item.isExp
      plain: => not method.nested()
      first: => @parent.len() > 0 and @index is 0
      last: => @index is (@parent.len() - 1)
      exp: => @isExp
      token: => @isToken
      block: => @caret.state is 'block'
      word: => @caret.state is 'word'
      indented: => @parent.indented
      align: => not @parent.indented

    for key in name.split(' ')
      return no unless method[key]()
    return yes

exports.Unit = Unit