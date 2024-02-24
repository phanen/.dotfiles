function k_cf
  set -l line "$(commandline)"
  if test -z "$(string trim -- $line)"
    __zoxide_zi
    commandline -f repaint
  else
    commandline -f forward-char
  end
end
