
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
    if (is indent 0)
      do $ renderSpan ":\n"
    renderSpan $ util.spaces (* indent 2)

  = increaseIndent $ \ ()
    = indent $ + indent 1

  = decreaseIndent $ \ ()
    = indent $ - indent 1

  = render $ \ (node index len inline level lucky afterDollar)
    -- console.log ":--> render" node index len afterDollar
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
      :array $ switch mode
        :line
          renderNewline
          = mode :start
          increaseIndent
          = noLuckyChild true
          node.forEach $ \ (child i)
            render child i node.length (is i 0) (+ level 1) noLuckyChild false
            if (util.isArray child)
              do $ = noLuckyChild false
          decreaseIndent
          = mode :line
        :text
          if (and (is (+ index 1) len) (not afterDollar))
            do
              renderSpan ": $"
              = noLuckyChild true
              node.forEach $ \ (child i)
                render child i node.length (is i 0) (+ level 1) noLuckyChild true
                if (util.isArray child)
                  do $ = noLuckyChild false
              = mode :line
            do $ if (and (util.isPlain node) lucky)
              do
                renderSpan ": ("
                = mode :start
                node.forEach $ \ (child i)
                  render child i node.length (is i 0) (+ level 1) true false
                renderSpan ":)"
                = mode :text
              do
                renderNewline
                = mode :start
                increaseIndent
                = noLuckyChild true
                node.forEach $ \ (child i)
                  render child i node.length (is i 0) (+ level 1) noLuckyChild false
                  if (util.isArray child)
                    do $ = noLuckyChild false
                decreaseIndent
                = mode :line
        :start $ if (and inline (> level 1))
          do
            renderSpan ":("
            = mode :start
            node.forEach $ \ (child i)
              render child i node.length true (+ level 1) false false
            renderSpan ":)"
            = mode :text
          do
            increaseIndent
            = noLuckyChild true
            node.forEach $ \ (child i)
              render child i node.length (is i 0) (+ level 1) true false
              if (util.isArray child)
                do $ = noLuckyChild false
            decreaseIndent
            = mode :line
    return buffer

  if (not (ast.every util.isArray))
    do $ throw $ new Error ":Cirru AST uses nested arrays"

  render ast 0 1 false 0 false false
