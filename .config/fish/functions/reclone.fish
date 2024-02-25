function reclone
  set -l url (git remote get-url origin)
  cd ~/b
  git clone $url
end
