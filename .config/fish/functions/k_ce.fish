function k_ce
  set -l line (commandline)
  if test -z "$(string trim -- $line)"
    # TODO: order matter
    set -l dir (fd . --type d -d 1 -I -H | fzf)
    if test -n "$dir"
      __zoxide_z "$dir"
    end
    commandline -f repaint
  else
    commandline -f end-of-line
  end
end
