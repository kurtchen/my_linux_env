#!/bin/bash
echo "Building development environment..."

CWD=`pwd`

echo "Step 1, index source files"
`find $CWD               \
-type f                  \
-name .repo -prune -o    \
-name .git -prune -o     \
-name .svn -prune -o     \
-name '*.java' -print -o \
-name '*.aidl' -print -o \
-name '*.hpp' -print -o  \
-name '*.cpp'  -print -o \
-name '*.cc'  -print -o \
-name '*.xml'  -print -o \
-name '*.mk'  -print -o  \
-name '*.go'  -print -o  \
-name '*.[chxsS]' -print > $CWD/myfilenametags`

echo "Step 2, build tags"
`ctags -R --fields=+im -L myfilenametags`
awk -F "|" 'length < 512' tags > tags.new
mv tags.new tags

#`find $CWD/system        \
#$CWD/frameworks          \
#$CWD/hardware            \
#$CWD/packages            \
#-type f                  \
#-name .repo -prune -o    \
#-name .git -prune -o     \
#-name '*.java' -print -o \
#-name '*.hpp' -print -o  \
#-name '*.cpp'  -print -o \
#-name '*.[ch]' -print > $CWD/cscope.files`

#echo "Step 3, building cscope files"
#`cscope -b -q`

echo "Step 4, building class path for syntastic"
`find $CWD/out -type d -name .repo -prune -o -name .git -prune -o -name 'classes' -print > .syntastic_javac_config`

echo "Done!"
