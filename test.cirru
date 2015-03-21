
= fs $ require :fs

= writer $ require :./src/writer

= name :demo

= sourceCode $ fs.readFileSync (++: :cirru/ name :.cirru)
= astCode $ fs.readFileSync (++: :ast/ name :.json)

= rendered $ writer.render $ JSON.parse astCode

console.log ":\nresults\n"

console.log rendered
