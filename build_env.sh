#!/bin/bash

function debug {
    if [ $VERBOSE -eq 1 ]; then
        echo "$1"
    fi
}

function info {
    echo "$1"
}

function create_file_name_tags {
    find $1                   \
    -type f                   \
    -name .repo -prune -o     \
    -name .git -prune -o      \
    -name .svn -prune -o      \
    -name '*.java' -print -o  \
    -name '*.aidl' -print -o  \
    -name '*.hpp'  -print -o  \
    -name '*.cpp'  -print -o  \
    -name '*.cc'   -print -o  \
    -name '*.xml'  -print -o  \
    -name '*.mk'   -print -o  \
    -name '*.go'   -print -o  \
    -name '*.js'   -print -o  \
    -name '*.py'   -print -o  \
    -name '*.php'  -print -o  \
    -name '*.[chxsS]' -print > $1/$2
}

RUN_CTAGS=1
RUN_FILENAME_TAGS=1
RUN_CSCOPE=0
RUN_SYNTASTIC_JAVA=0

CTAGS_OPT="default"

RUN_FILENAME_TAGS_OVERRIDE=0
SYNTASTIC_JAVA_DIR="out"

VERBOSE=0
HELP=0

unset OPTIND
while getopts ":tg:fcjd:vh" option; do
    case $option in
        t) RUN_CTAGS=1 ;;
        f) RUN_FILENAME_TAGS=1 ;;
        c) RUN_CSCOPE=1 ;;
        j) RUN_SYNTASTIC_JAVA=1 ;;
        g) CTAGS_OPT=$OPTARG ;;
        d) SYNTASTIC_JAVA_DIR=$OPTARG ;;
        v) VERBOSE=1 ;;
        h) HELP=1 ;;
    esac
done && shift $(($OPTIND - 1))

if [ $HELP -eq 1 ]; then
    echo "$0"
    echo "Usage:"
    echo "    -t : run ctags"
    echo "    -f : create file name tags for fuzzy finder"
    echo "    -c : run cscope"
    echo "    -j : create java classpath for syntastic"
    echo "    -g CTAGS_OPT: default or file, file mode create tags based on file list"
    echo "    -d SYNTASTIC_JAVA_DIR: search directory for building java classpath"
    echo "    -v : print verbose info"
    echo "    -h : this help message"
    exit 0
fi

info "Building development environment..."

CWD=`pwd`
CUR_STEP=1

if [ $RUN_CTAGS -eq 1 ]; then

    if [ "$CTAGS_OPT" == "default" ]; then
        echo "Step $CUR_STEP, build tags"
        let CUR_STEP=$CUR_STEP+1

        ctags -R --fields=+im

        if [ $RUN_FILENAME_TAGS -eq 1 ]; then
            echo "Step $CUR_STEP, index source files"
            let CUR_STEP=$CUR_STEP+1
        fi

    else
        if [ $RUN_FILENAME_TAGS -eq 1 ]; then
            echo "Step $CUR_STEP, index source files"
            let CUR_STEP=$CUR_STEP+1
        fi

        create_file_name_tags $CWD myfilenametags.tmp
        RUN_FILENAME_TAGS_OVERRIDE=1

        echo "Step $CUR_STEP, build tags"
        let CUR_STEP=$CUR_STEP+1

        ctags -R --fields=+im -L $CWD/myfilenametags.tmp

        if [ $RUN_FILENAME_TAGS -eq 1 ]; then
            mv $CWD/myfilenametags.tmp $CWD/myfilenametags
        else
            rm -rf $CWD/myfilenametags.tmp
        fi
    fi

    awk -F "|" 'length < 512' tags > tags.new
    mv tags.new tags
fi

if [[ $RUN_FILENAME_TAGS -eq 1 && $RUN_FILENAME_TAGS_OVERRIDE -eq 0 ]]; then
    echo "Step $CUR_STEP, index source files"
    let CUR_STEP=$CUR_STEP+1

    create_file_name_tags $CWD myfilenametags
fi

if [ $RUN_CSCOPE -eq 1 ]; then
    echo "Step $CUR_STEP, build cscope files"
    let CUR_STEP=$CUR_STEP+1

    create_file_name_tags $CWD cscope.files
    cscope -b -q
fi

if [ $RUN_SYNTASTIC_JAVA -eq 1 ]; then
    echo "Step $CUR_STEP, build class path for java syntastic"
    find $CWD/$SYNTASTIC_JAVA_DIR -type d -name .repo -prune -o -name .git -prune -o -name 'classes' -print > .syntastic_javac_config
fi

echo "Done!"
