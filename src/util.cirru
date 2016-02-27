
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
  cond (text.match "/^[^\\\"\\s\\(\\)]+$")
    , text
    JSON.stringify text

= exports.isPlain $ \ (list)
  cond (is list.length 0) true
    list.every $ \ (child)
      is (exports.type child) :string

= exports.isArray $ \ (x)
  return $ is (exports.type x) :array

= exports.isDeep $ \ (ast)
  cond (Array.isArray ast)
    > (getListLevel ast) 2
    , false

var $ trimRightSpace $ \ (text)
  var
    end $ - text.length 1
    last $ . text end
  cond (is last ": ")
    trimRightSpace (text.substr 0 end)
    , text

= exports.trimRightSpace $ \ (text)
  return $ trimRightSpace text
