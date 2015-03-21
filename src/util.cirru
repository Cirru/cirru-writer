
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
