#!/bin/bash
# for chromebook c1030
TOUCHPAD_IS_ENABLE=$(xinput list-props 'Elan Touchpad' | ag 'Device Enable' | awk '{print $NF}')
if [[ "$TOUCHPAD_IS_ENABLE" = 1 ]]; then
  xinput disable 'Elan Touchpad'
else
  xinput enable 'Elan Touchpad'
fi
