
var
  util $ require :./util
  transformer $ require :./transformer
  noLuckyChild

  isString $ \ (x)
    is (typeof x) :string

  isArray $ \ (x)
    Array.isArray x

  textSegment $ \ (token)
    {} :type :token :data $ util.markToken token

  controlSegment $ \ (op)
    {} :type :control :data op

  renderInline $ \ (x)
    cond (isString x) (util.markToken x)
      ... x
        map renderInline
        join ": "

  getTokenOrExpression $ \ (x)
    cond (isString x) :string :expression

  joinExpressions $ \ (acc tree lastType isLastDeep)
    cond (is lastType :start)
      joinExpressions
        acc.concat
          textSegment $ renderInline (. tree 0)
          controlSegment :indent
        tree.slice 1
        , :token false
      cond (is tree.length 0)
        acc.concat $ controlSegment :unindent
        bind
          getTokenOrExpression (. tree 0)
          \ (thisType)
            joinExpressions
              cond (is thisType :string)
                cond (is lastType :string)
                  acc.concat (textSegment ": ") (textSegment (. tree 0))
                  acc.concat (textSegment ":\n") (textSegment (. tree 0))
                acc.concat
                  textSegment $ cond isLastDeep ":\n\n" ":\n"
                  [] (handleExpression . tree 0)
              tree.slice 1
              , thisType
              util.isDeep (. tree 0)

  handleExpression $ \ (tree)
    tree.map $ \ (item)
      cond (isString item)
        textSegment item
        cond (util.isSmallExpression item)
          textSegment $ + ":("
            ... item (map util.markToken) (join ": ")
            , ":)"
          joinExpressions ([]) $ tree.map $ \ (child)
            cond (isString child)
              util.markToken child
              handleExpression tree
            , :start

  joinLines $ \ (acc tree)
    cond (is tree.length 0) acc
      joinLines
        acc.concat
          textSegment ":\n\n"
          tree.slice 0 1
        tree.slice 1

  handleAST $ \ (tree)
    var
      lines $ tree.map handleExpression
    joinLines lines

  flattenSegments $ \ (acc tree)
    cond (is tree.length 0) acc
      acc.concat
        bind (. tree 0) $ \ (cursor)
          cond (isArray cursor) cursor
            flattenSegments ([]) cursor
        tree.slice 1

  stringifySegments $ \ (acc indentation segments)
    cond (is segments.length 0) acc
      bind (. segments 0) $ \ (head)
        stringifySegments
          + acc $ case head.type
            :token head.data
            else :
          case (is head.type :control)
            case head.data
              :indent $ + indentation ": "
              :unindent $ indentation.slice 1
            , indentation
          segments.slice 1

= exports.render $ \ (ast)
  var
    fatAst $ transformer.insertDollar $ transformer.insertComma ast
    segments $ handleAST fatAst
    flattened $ flattenSegments ([]) segments
  stringifySegments : flattened
