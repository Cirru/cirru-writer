
var
  stir $ require :stir-template
  html stir.html
  head stir.head
  body stir.body
  div stir.div
  link $ stir.createFactory :link
  script $ stir.createFactory :script
  meta $ stir.createFactory :meta
  style $ stir.createFactory :style
  title $ stir.createFactory :title
  textarea $ stir.createFactory :textarea

= module.exports $ \ (data)
  return $ stir.render
    stir.doctype
    html null
      head null
        title null ":Cirru Writer"
        meta $ object (:charset :utf-8)
        script $ object (:src data.main) (:defer true)
      body null
        textarea (object (:id :source))
        textarea (object (:id :compiled))
