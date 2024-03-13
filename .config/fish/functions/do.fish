function do
  # TODO: async
  for i in (seq 1 $argv[1])
    eval $argv[2..]
  end
end
