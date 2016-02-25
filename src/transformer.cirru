
var
  bind $ \ (v k) (k v)

  commaList $ [] :,

  isString $ \ (x)
    is (typeof x) :string

  transformComma $ \ (acc buffer tree isLastInline)
    -- console.log :transformComma acc buffer tree isLastInline
    cond (is tree.length 0)
      cond (is buffer.length 0) acc
        acc.concat $ [] $ commaList.concat buffer
      cond (is acc.length 0)
        transformComma (acc.concat (tree.slice 0 1)) buffer (tree.slice 1) true
        bind
          isString $ . tree 0
          \ (isThisInline)
            case true
              (and isLastInline isThisInline) $ cond (is buffer.length 0)
                transformComma (acc.concat $ tree.slice 0 1) ([]) (tree.slice 1) true
                transformComma acc (buffer.concat $ tree.slice 0 1) (tree.slice 1) true
              (and (not isLastInline) isThisInline)
                transformComma acc (buffer.concat $ tree.slice 0 1) (tree.slice 1) true
              (and isLastInline (not isThisInline)) $ cond (is buffer.length 0)
                transformComma (acc.concat $ tree.slice 0 1) ([]) (tree.slice 1) false
                transformComma
                  acc.concat
                    [] $ commaList.concat buffer
                    tree.slice 0 1
                  , ([]) (tree.slice 1) false
              else $ transformComma (acc.concat $ tree.slice 0 1) ([]) (tree.slice 1) false

  insertComma $ \ (tree)
    tree.map $ \ (line)
      transformComma ([]) ([]) line true

  transformDollar $ \ (acc tree isLastInline index)
    case tree.length
      0 acc
      1 $ cond isLastInline
        cond
          and (> index 0) (Array.isArray (. tree 0))
          acc.concat :$ (. tree 0)
          acc.concat tree
        acc.concat tree
      else $ transformDollar
        acc.concat $ bind (. tree 0) $ \ (cursor)
          cond (Array.isArray cursor)
            [] $ transformDollar ([]) cursor true 0
            tree.slice 0 1
        tree.slice 1
        isString $ . tree 0
        + index 1

  insertDollar $ \ (tree)
    tree.map $ \ (line)
      transformDollar ([]) line true 0

= exports.insertComma insertComma
= exports.insertDollar insertDollar
