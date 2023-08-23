---@diagnostic disable: undefined-global

local function fn(
  args, -- text from i(2) in this example i.e. { { "456" } }
  parent, -- parent snippet or parent node
  user_args -- user_args from opts.user_args
)
  return "[" .. args[1][1] .. user_args .. "]"
end

-- stylua: ignore
return {

  s("trig", {
    i(1), t '<-i(1) ',
    f(fn, { 2 }, { user_args = { "user_args_value" } }),
    t ' i(2)->', i(2), t '<-i(2) i(0)->', i(0)
  })
}
