#!/bin/bash

#export DISPLAY="shsxll003:8"

TERM_CMD_1="xterm -u8 -geometry 80x20+0+0 -e enter_oc6"
TERM_CMD_2="xterm -u8 -geometry 80x20+751+0 -e enter_oc6"
TERM_CMD_3="xterm -u8 -geometry 80x20+0+400 -e enter_oc6"
TERM_CMD_4="xterm -u8 -geometry 80x20+751+400 -e enter_oc6"

echo "Starting xterm 1 ..."
$TERM_CMD_1 &
echo "Starting xterm 2 ..."
$TERM_CMD_2 &
echo "Starting xterm 3 ..."
$TERM_CMD_3 &
echo "Starting xterm 4 ..."
$TERM_CMD_4 &
echo "done"
