function git-date
  set -q $argv
  and set d (date -d 'now' +%y-%m-%d)
  or set d $argv
  set t (printf "%02d:%02d:%02d" (random 0 4) (random 0 60) (random 0 60))
  set commit_date $d $t
  set commit_date (date -d "$commit_date" --rfc-2822)
  echo $commit_date
  set gc git commit --amend --no-edit --allow-empty-message
  LC_ALL=C GIT_COMMITTER_DATE="$commit_date" $gc --date "$commit_date"
end
