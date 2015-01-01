#!/bin/bash
echo "Building cscope environment for current module..."

CWD=`pwd`

echo "Step 1, index source files"

`find $CWD        \
-type f                  \
-name .repo -prune -o    \
-name .git -prune -o     \
-name .svn -prune -o     \
-name '*.java' -print -o \
-name '*.hpp' -print -o  \
-name '*.cpp'  -print -o \
-name '*.cc' -print -o  \
-name '*.[ch]' -print > $CWD/cscope.files`

echo "Step 2, building cscope files"
`cscope -b -q`

echo "Done!"
