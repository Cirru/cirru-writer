
var
  util $ require :./util
  transformer $ require :./transformer
  noLuckyChild

= exports.render $ \ (ast)
  console.log $ JSON.stringify ast null 2
  console.log $ JSON.stringify (transformer.insertDollar ast) null 2
  console.log $ JSON.stringify (transformer.insertComma ast) null 2

  var
    buffer :
    indent -1
    mode :line

    renderSpan $ \ (text)
      -- console.log :render :span (JSON.stringify text)
      = buffer $ + buffer text

    renderNewline $ \ ()
      = buffer $ util.trimRightSpace buffer
      renderSpan ":\n"
      renderSpan $ util.spaces (* indent 2)

    increaseIndent $ \ ()
      = indent $ + indent 1

    decreaseIndent $ \ ()
      = indent $ - indent 1

  var $ render $ \ (node parent index inline lucky afterDollar)
    -- console.log ":--> render" mode index (JSON.stringify node)
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
          if
            util.isDeep (. parent (- index 1))
            do $ renderNewline
          = mode :start
          increaseIndent
          = noLuckyChild true
          node.forEach $ \ (child i)
            render child node i (is i 0) noLuckyChild false
            if (util.isArray child)
              do $ = noLuckyChild false
            return
          decreaseIndent
          = mode :line
        :text
          if inline
            do
              renderSpan ": ("
              = mode :start
              node.forEach $ \ (child i)
                render child node i (is i 0) true false
              renderSpan ":)"
              = mode :text
              return null

          if (and (is (+ index 1) parent.length) (not afterDollar))
            do
              renderSpan ": $"
              = noLuckyChild true
              node.forEach $ \ (child i)
                render child node i (is i 0) noLuckyChild true
                if (util.isArray child)
                  do $ = noLuckyChild false
                return
              = mode :line
            do $ if (and (util.isPlain node) lucky)
              do
                renderSpan ": ("
                = mode :start
                node.forEach $ \ (child i)
                  render child node i (is i 0) true false
                renderSpan ":)"
                = mode :text
              do
                renderNewline
                = mode :start
                increaseIndent
                = noLuckyChild true
                node.forEach $ \ (child i)
                  render child node i (is i 0) noLuckyChild false
                  if (util.isArray child)
                    do $ = noLuckyChild false
                  return
                decreaseIndent
                = mode :line
        :start $ if (and inline (isnt parent ast))
          do
            renderSpan ":("
            = mode :start
            node.forEach $ \ (child i)
              render child node i true false false
            renderSpan ":)"
            = mode :text
          do
            increaseIndent
            = noLuckyChild true
            node.forEach $ \ (child i)
              render child node i (is i 0) true false
              if (util.isArray child)
                do $ = noLuckyChild false
              return
            decreaseIndent
            = mode :line
    return $ + buffer ":\n"

  if (not (ast.every util.isArray))
    do $ throw $ new Error ":Cirru AST uses nested arrays"

  return $ render ast (array) 1 false false false
