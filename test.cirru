
var
  fs $ require :fs
  writer $ require :./src/writer
  names $ array :demo :folding :html :indent :line
    , :parentheses :quote :spaces :unfolding :inline-let

names.forEach $ \ (name)
  var
    sourceCode $ fs.readFileSync (+ :cirru/ name :.cirru) :utf8
    astCode $ fs.readFileSync (+ :ast/ name :.json) :utf8

    rendered $ writer.render $ JSON.parse astCode
  if
    is
      ... rendered (replace (new RegExp ":\\n\\s+\\n" :g) ":\n\n") (trim)
      sourceCode.trim
    do $ console.log ":% % ok" name
    do $ console.log ":\n--> failed" name ":\n" rendered
  return
