
var $ getListLevel $ \ (list)
  var
    numList $ list.map $ \ (item)
      return $ cond (Array.isArray item)
        + (getListLevel item) 1
        , 1
  return $ Math.max (... numList)

var $ makeSpace $ \ (buffer n)
  return $ cond (> n 0)
    makeSpace (+ buffer ": ") (- n 1)
    , buffer

= exports.spaces $ \ (n)
  return $ makeSpace : n

= exports.type $ \ (x)
  var
    info $ Object.prototype.toString.call x
    theType $ info.slice 8 -1
  return $ theType.toLowerCase

= exports.markToken $ \ (text)
  if (text.match "/^[^\\\"\\s$\\(\\)]+$")
    do $ return text
    do $ return $ JSON.stringify text

= exports.isPlain $ \ (list)
  return $ list.every $ \ (child)
    return $ is (exports.type child) :string

= exports.isArray $ \ (x)
  return $ is (exports.type x) :array

= exports.isDeep $ \ (ast)
  if (Array.isArray ast)
    do
      var $ level $ getListLevel ast
      return $ > level 2
    do $ return false

var $ trimRightSpace $ \ (text)
  var
    end $ - text.length 1
    last $ . text end
  if (is last ": ")
    do $ return $ trimRightSpace (text.substr 0 end)
    do $ return text

= exports.trimRightSpace $ \ (text)
  return $ trimRightSpace text
