
id=$(xdotool getactivewindow)

if [ "$(xdotool getactivewindow getwindowclassname)" == "tdrop-kitty" ]
then
    xdotool windowunmap $id
fi

pkill xdotool

# xdotool behave $id blur exec $XDG_CONFIG_HOME/sxhkd/unmap_if_tdrop.sh $id
