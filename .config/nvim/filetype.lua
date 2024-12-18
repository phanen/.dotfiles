vim.filetype.add({
  extension = {
    h = function(path) -- c or cpp
      local has_cpp_file_in_header_dir = function()
        local stem = fn.fnamemodify(path, ':r')
        return uv.fs_stat(string.format('%s.cc', stem)) or uv.fs_stat(string.format('%s.cpp', stem))
      end

      local contain_cpp_specific_keywords = function()
        return fn.search(
          ([[\C\%%(%s\)]]):format(
            table.concat {
              [[^#include <[^>.]\+>$]],
              [[\<constexpr\>]],
              [[\<consteval\>]],
              [[\<extern "C"\>]],
              [[^class\> [A-Z]],
              [[^\s*using\>]],
              [[\<template\>\s*<]],
              [[\<std::]],
            },
            '\\|'
          ),
          'nw'
        ) ~= 0
      end

      return (has_cpp_file_in_header_dir() or contain_cpp_specific_keywords()) and 'cpp' or 'c'
    end,
  },
})
