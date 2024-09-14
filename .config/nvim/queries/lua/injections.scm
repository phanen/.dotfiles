;; extends

(function_call
  name: (_) @_map
  arguments:
    (arguments
      . (_)
      .
      (string
        content: (_) @injection.content))
  (#any-of? @_map "nx.expr" "n.expr")
  (#set! injection.language "vim"))


