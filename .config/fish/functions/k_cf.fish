function k_cf
  set -l line "$(commandline)"
  if test -z "$(string trim -- $line)"
    set -l res "$(_ZO_FZF_OPTS=$FZF_DEFAULT_OPTS zoxide query -i)"
    if test -n $res
      cd $res
    end
    commandline -f repaint
  else
    commandline -f forward-char
  end
end
