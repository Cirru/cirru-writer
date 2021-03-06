
var
  bind $ \ (v k) (k v)

  commaList $ [] :,

  isString $ \ (x)
    is (typeof x) :string

  upHeadComma $ \ (tree)
    var
      head $ . tree 0
    cond (isString head)
      tree.slice 0 1
      [] $ transformComma ([]) ([]) head true

  transformComma $ \ (acc buffer tree isLastInline)
    -- console.log :transformComma acc buffer tree isLastInline
    cond (is tree.length 0)
      cond (is buffer.length 0) acc
        acc.concat $ [] $ commaList.concat buffer
      cond (is acc.length 0)
        transformComma (acc.concat $ upHeadComma tree) buffer (tree.slice 1) true
        bind
          isString $ . tree 0
          \ (isThisInline)
            case true
              (and isLastInline isThisInline) $ cond (is buffer.length 0)
                transformComma (acc.concat $ upHeadComma tree) ([]) (tree.slice 1) true
                transformComma acc (buffer.concat $ upHeadComma tree) (tree.slice 1) true
              (and (not isLastInline) isThisInline)
                transformComma acc (buffer.concat $ upHeadComma tree) (tree.slice 1) true
              (and isLastInline (not isThisInline)) $ cond (is buffer.length 0)
                transformComma (acc.concat $ upHeadComma tree) ([]) (tree.slice 1) false
                transformComma
                  acc.concat
                    [] $ commaList.concat buffer
                    upHeadComma tree
                  , ([]) (tree.slice 1) false
              else $ transformComma (acc.concat $ upHeadComma tree) ([]) (tree.slice 1) false

  insertComma $ \ (tree)
    tree.map $ \ (line)
      transformComma ([]) ([]) line true

  upDollar $ \ (head usingDollar)
    cond (isString head) head
      transformDollar ([]) head true 0 usingDollar

  transformDollar $ \ (acc tree isLastInline index usingDollar)
    case tree.length
      0 acc
      1 $ bind (. tree 0) $ \ (head)
        cond
          and isLastInline (> index 0) (Array.isArray head) (not usingDollar)
          acc.concat :$ (upDollar head true)
          acc.concat $ [] $ upDollar head false
      else $ transformDollar
        acc.concat $ [] $ upDollar (. tree 0) false
        tree.slice 1
        isString $ . tree 0
        + index 1
        , usingDollar

  insertDollar $ \ (tree)
    tree.map $ \ (line)
      transformDollar ([]) line true 0 false

= exports.insertComma insertComma
= exports.insertDollar insertDollar
