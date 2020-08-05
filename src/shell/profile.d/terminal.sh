termite="$(which termite 2>/dev/null)"
terminology="$(which terminology 2>/dev/null)"
xcfe4terminal="$(which xcfe4-terminal 2>/dev/null)"
qterminal="$(which qterminal-terminal 2>/dev/null)"
gnometerminal="$(which gnome-terminal 2>/dev/null)"
xterm="$(which xterm 2>/dev/null)"
uxterm="$(which uxterm 2>/dev/null)"

if [[ -n "$termite" ]]; then
export MYTERM=termite
elif [[ -n "$terminology" ]]; then
export MYTERM=terminology
elif [[ -n "$xcfe4terminal" ]]; then
export MYTERM=xcfe4-terminal
elif [[ -n "$qterminal" ]]; then
export MYTERM=qterminal-terminal
elif [[ -n "$gnometerminal" ]]; then
export MYTERM=gnome-terminal
elif [[ -n "$xterm" ]]; then
export MYTERM=xterm
elif [[ -n "$uxterm" ]]; then
export MYTERM=uxterm
fi

terminal() { $MYTERM; }
