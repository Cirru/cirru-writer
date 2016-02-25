
var
  bind $ \ (v k) (k v)

  commaList $ [] :,

  isString $ \ (x)
    is (typeof x) :string

  transformComma $ \ (acc buffer tree isLastInline)
    cond (is tree.length 0)
      cond (> buffer.length 0)
        acc.concat $ [] $ commaList.concat buffer
        , acc
      cond (= acc.length 0)
        transformComma (acc.concat (tree.slice 0 1)) buffer (tree.slice 1) true
        bind
          isString $ . tree 0
          \ (isThisInline)
            case true
              (and isLastInline isThisInline) $ cond (is buffer.length 0)
                transformComma (acc.concat tree.slice 0 1) ([]) (tree.slice 1) true
                transformComma acc (buffer.concat $ tree.slice 0 1) (tree.slice 1) true
              (and (not isLastInline) isThisInline)
                transformComma acc (buffer.concat $ tree.slice 0 1) (tree.slice 1) true
              (and isLastInline (not isThisInline)) $ cond (is buffer.length 0)
                transformComma (acc.concat $ tree.slice 0 1) ([]) (tree.slice 1) false
                transformComma
                  acc.concat
                    [] $ commaList.concat buffer
                    tree.slice 0 1
                  , buffer (tree.slice 1) false
              else $ transformComma (acc.concat $ tree.slice 0 1) ([]) (tree.slice 1) false

  transformDollar $ \ (acc tree)
    case tree.length
      0 acc
      1 $ cond (Array.isArray (. tree 0))
        acc.concat :$ (. tree 0)
      else $ transformDollar
        acc.concat $ tree.slice 0 1
        tree.slice 1

  insertComma $ \ (tree)
    tree.map $ \ (line)
      transformComma ([]) ([]) line true

  insertDollar $ \ (tree)
    tree.map $ \ (line)
      transformDollar ([]) line

= exports.insertComma insertComma
= exports.insertDollar insertDollar
