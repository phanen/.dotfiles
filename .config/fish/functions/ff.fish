function ff --wrap "paru -G"
  mkdir -p /tmp/tmp
  cd /tmp/tmp
  paru -G $argv
end

