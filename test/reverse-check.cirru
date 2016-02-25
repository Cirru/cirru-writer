
var
  fs $ require :fs
  path $ require :path
  parser $ require :cirru-parser
  names $ array :demo :folding :html :indent :line
    , :parentheses :quote :spaces :unfolding :inline-let

names.forEach $ \ (name)
  var
    cirruFile $ path.join :cirru/ (+ name :.cirru)
    jsonFile $ path.join :ast/ (+ name :.json)
    cirruString $ JSON.stringify $ parser.pare
      fs.readFileSync cirruFile :utf8
      , :
    jsonString $ JSON.stringify $ JSON.parse
      fs.readFileSync jsonFile :utf8
      , :
  console.log name (is cirruString jsonString)
