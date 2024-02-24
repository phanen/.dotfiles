function k_cg
  set -l line "$(commandline)"
  if test -z "$(string trim -- $line)"
    yazi
  else
    __fish_lookup
  end
end

function __fish_lookup
  set -l args (string match -rv '^-|^$' -- (commandline -cpo && commandline -t))
  if not set -q args[1]
    printf \a
    return
  end

  while set -q args[2]
    and string match -qr -- '^(and|begin|builtin|caffeinate|command|doas|entr|env|exec|if|mosh|nice|not|or|pipenv|prime-run|setsid|sudo|systemd-nspawn|time|watch|while|xargs|.*=.*)$' $args[1]
    set -e args[1]
  end

  # If there are at least two tokens not starting with "-", the second one might be a subcommand.
  # Try "tldr first-second" and fall back to "tldr first" if that doesn't work out.
  set -l maincmd (basename $args[1])
  # HACK: If stderr is not attached to a terminal `less` (the default pager)
  # wouldn't use the alternate screen.
  # But since we don't know what pager it is, and because `tldr` is totally underspecified,
  # the best we can do is to *try* the tldr page, and assume that `tldr` will return false if it fails.
  # See #7863.
  if set -q args[2]
    and not string match -q -- '*/*' $args[2]
    and tldr "$maincmd-$args[2]" &>/dev/null
    tldr "$maincmd-$args[2]"
  else
    if tldr "$maincmd" &>/dev/null
      tldr "$maincmd"
    else if type -q "$maincmd"
      type -a "$maincmd"
    else
      printf \a
    end
  end
  commandline -f repaint
end
