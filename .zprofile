if [[ "$(tty)" = "/dev/tty1" ]]; then
  pgrep i3 || startx > /dev/null 2>&1
fi


