
cond
  (and (> a 1) true) (+ a 1)
  (or (< a 1) false) (- a 1)
  :else a
