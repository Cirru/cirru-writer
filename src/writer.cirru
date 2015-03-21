
= util $ require :./util

= exports.render $ \ (ast)

  = buffer :
  = indent -1
  = mode :line

  = renderSpan $ \ (text)
    -- console.log :render :span (JSON.stringify text)
    = buffer $ ++: buffer text

  = renderNewline $ \ ()
    renderSpan ":\n"
    renderSpan $ util.spaces (* indent 2)

  = increaseIndent $ \ ()
    = indent $ + indent 1

  = decreaseIndent $ \ ()
    = indent $ - indent 1

  = render $ \ (node index len)
    -- console.log ":\n--> render" node index len
    switch (util.type node)
      :string $ switch mode
        :line
          renderNewline
          renderSpan ":, "
          renderSpan $ util.markToken node
          = mode :text
        :text
          renderSpan ": "
          renderSpan $ util.markToken node
        :start
          renderSpan $ util.markToken node
          = mode :text
        :close
          renderSpan ": "
          renderSpan $ util.markToken node
          = mode :text
      :array $ switch mode
        :line
          renderNewline
          = mode :start
          increaseIndent
          node.forEach $ \ (child i)
            render child i node.length
          decreaseIndent
          = mode :line
        :text
          renderNewline
          = mode :start
          increaseIndent
          node.forEach $ \ (child i)
            render child i node.length
          decreaseIndent
          = mode :line
        :start
          increaseIndent
          node.forEach $ \ (child i)
            render child i node.length
          decreaseIndent
          = mode :line
        :close
    return buffer

  render ast 0 1
