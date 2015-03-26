
= getListLevel $ \ (list)
  = numList $ list.map $ \ (item)
    if (Array.isArray item)
      do $ + (getListLevel item) 1
      do 1
  Math.max.apply this numList

= makeSpace $ \ (buffer n)
  if (> n 0)
    do $ makeSpace (++: buffer ": ") (- n 1)
    do buffer

= exports.spaces $ \ (n)
  makeSpace : n

= exports.type $ \ (x)
  = info $ Object.prototype.toString.call x
  = theType $ info.slice 8 -1
  theType.toLowerCase

= exports.markToken $ \ (text)
  if (text.match "/^[^\\\"\\s$\\(\\)]+$")
    do text
    do $ JSON.stringify text

= exports.isPlain $ \ (list)
  list.every $ \ (child)
    is (exports.type child) :string

= exports.isArray $ \ (x)
  is (exports.type x) :array

= exports.isDeep $ \ (ast)
  if (Array.isArray ast)
    do
      = level $ getListLevel ast
      > level 2
    do false

= trimRightSpace $ \ (text)
  = end $ - text.length 1
  = last $ . text end
  if (is last ": ")
    do $ trimRightSpace (text.substr 0 end)
    do text

= exports.trimRightSpace $ \ (text)
  trimRightSpace text
