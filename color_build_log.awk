#!/bin/awk -f

function red(s) {
    printf "\033[1;31m" s "\033[0m "
}

function green(s) {
    printf "\033[1;32m" s "\033[0m "
}

function blue(s) {
    printf "\033[1;34m" s "\033[0m "
}

BEGIN {
    FS = ":"
    #binaries = []
    binaries_count = 0
}

{
    if ($1 == "Install") {
        binaries[binaries_count] = $0
        binaries_count++

        green($0)
        print ORS
    } else if ($NF ~ ".* Error .*") {
        red($0)
        print ORS
    }else {
        print
    }
}

END {
    if (binaries_count > 0) {
        blue("==>BINARIES<==")
        print ORS

        for (b in binaries) {
            blue(binaries[b])
            print ORS
        }
    }
}
