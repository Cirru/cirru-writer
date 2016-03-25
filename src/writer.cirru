
var
  util $ require :./util
  transformer $ require :./transformer

  bind $ \ (v k) (k v)

  isString $ \ (x)
    is (typeof x) :string

  isArray $ \ (x)
    Array.isArray x

  tokenSegment $ \ (token)
    {} :type :token :data $ util.markToken token

  textSegment $ \ (token)
    {} :type :token :data token

  controlSegment $ \ (op)
    {} :type :control :data op

  renderInline $ \ (x)
    cond (isString x) (util.markToken x)
      + ":("
        ... x
          map renderInline
          join ": "
        , ":)"

  getTokenOrExpression $ \ (x)
    cond (isString x) :string :expression

  joinExpressions $ \ (acc tree lastType isLastDeep level)
    cond (is lastType :start)
      cond
        or
          isString (. tree 0)
          util.isSmallExpression (. tree 0)
          < level 1
        joinExpressions
          acc.concat
            textSegment $ renderInline (. tree 0)
            controlSegment :indent
          tree.slice 1
          , :string false (+ level 1)
        joinExpressions
          acc.concat
            textSegment ":  "
            controlSegment :indent
            handleExpression (. tree 0) (+ level 1)
          tree.slice 1
          , :expression false (+ level 1)
      cond (is tree.length 0)
        acc.concat $ controlSegment :unindent
        bind (. tree 0) $ \ (cursor)
          bind (getTokenOrExpression cursor) $ \ (thisType)
            joinExpressions
              cond (is thisType :string)
                cond (is lastType :string)
                  acc.concat (textSegment ": ") (tokenSegment cursor)
                  acc.concat (controlSegment :newline) (tokenSegment cursor)
                cond
                  and (is lastType :string) (util.isSmallExpression cursor)
                  acc.concat
                    textSegment ": "
                    textSegment $ renderInline cursor
                  cond isLastDeep
                    acc.concat
                      controlSegment :newline
                      controlSegment :newline
                      [] $ handleExpression cursor (+ level 1)
                    acc.concat
                      controlSegment :newline
                      [] $ handleExpression cursor (+ level 1)
              tree.slice 1
              , thisType
              util.isDeep cursor
              + level 1

  handleExpression $ \ (tree level)
    joinExpressions ([]) tree :start false level

  joinLines $ \ (acc tree)
    cond (is tree.length 0) acc
      joinLines
        acc.concat
          controlSegment :newline
          tree.slice 0 1
          controlSegment :newline
        tree.slice 1

  handleAST $ \ (tree)
    var
      lines $ tree.map $ \ (line)
        handleExpression line 0
    joinLines ([]) lines

  flattenSegments $ \ (acc tree)
    cond (is tree.length 0) acc
      flattenSegments
        acc.concat
          bind (. tree 0) $ \ (cursor)
            cond (isArray cursor)
              flattenSegments ([]) cursor
              , cursor
        tree.slice 1

  stringifySegments $ \ (acc indentation segments)
    cond (is segments.length 0) acc
      bind (. segments 0) $ \ (head)
        stringifySegments
          + acc $ case head.type
            :token head.data
            :control $ case head.data
              :newline $ + ":\n" indentation
              else :
            else :
          cond (is head.type :control)
            case head.data
              :indent $ + indentation ":  "
              :unindent $ indentation.slice 2
              else indentation
            , indentation
          segments.slice 1

= exports.render $ \ (ast)
  var
    fatAst $ transformer.insertDollar $ transformer.insertComma ast
    segments $ handleAST fatAst
    flattened $ flattenSegments ([]) segments
    result $ stringifySegments : : flattened
  result.replace (new RegExp ":\\n\\s+\\n" :g) ":\n\n"
