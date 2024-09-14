local Lodash = {}

Lodash.debounce = function(ms, fn)
  local timer = assert(vim.uv.new_timer())
  return function(...)
    local argc, argv = select('#', ...), { ... }
    timer:start(ms, 0, function()
      timer:stop()
      vim.schedule(function() fn(unpack(argv, 1, argc)) end)
    end)
  end
end

return Lodash
