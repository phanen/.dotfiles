function k_ct
  set -l line (commandline)
  if test -z (string trim $line)
    commandline -r $history[1]
    commandline -f execute
    return
  end
  set -l part (commandline -p)
  set line (string replace $part "" $line)
  commandline -r $line
end
