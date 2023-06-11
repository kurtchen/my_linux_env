#!/bin/bash

#set -euEo pipefail
set -e 

# Hacks

# Constants
readonly MY_SCRIPT_DIR="$( cd "$(dirname "$0")" && pwd )"

readonly INITIAL_DEBUG_LEVEL=1
readonly _CONST_DEBUG_LEVEL=1    # 0 means no debug; positive numbers increase verbosity

readonly DEFAULT_APP_NAME="my_linux_env"
readonly DEFAULT_APP_PATH="${HOME}/.my_linux_env"
readonly DEFAULT_APP_REPO="https://github.com/kurtchen/my_linux_env.git"
readonly DEFAULT_APP_REPO_BRANCH="master"

readonly DEFAULT_VIM_PLUG_URL="https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim"

# Globals
DEBUG_LEVEL=2

APP_NAME="${DEFAULT_APP_NAME}"
APP_PATH="${DEFAULT_APP_PATH}"
APP_REPO="${DEFAULT_APP_REPO}"
APP_REPO_BRANCH="${DEFAULT_APP_REPO_BRANCH}"

VIM_PLUG_URL="${DEFAULT_VIM_PLUG_URL}"

show_help() {
    echo "Usage: $0 [OPTIONS]
This script is used to bootstrap my linux develop enviroment.

Options:
-d, --debug                         Enable debug log.
-h, --help                          Show this help screen.
"
}

########## Log utils ##########
stderr(){
    echo "*** $*" >&2
}
notice(){
    stderr "NOTICE: $*"
}
warn(){
    stderr "WARNING: $*"
}
die(){
    local _EXIT_CODE=$(( $? == 0 ? 99 : $? ))
    stderr "ERROR: $*"
    exit ${_EXIT_CODE}
}
debug(){
    local _LEVEL=1
    [ $# -gt 1 ] && { _LEVEL="$1" ; shift ;}
    [ "${_LEVEL}" -le "${_CONST_DEBUG_LEVEL}" ] && stderr "DEBUG[${_LEVEL}]: $*"
    return 0
}

########## Handle arguments ##########
parse_parameters(){
    debug ${INITIAL_DEBUG_LEVEL} "++ parse_parameters ($@)"

    while [ $# -gt 0 ] ; do
        case "$1" in
#            -a|--apple)
#                APPLE="${2:-}"
#                shift; shift;;
#            -b|--ball)
#                BALL="${2:-${DEFAULT_BALL}}"
#                shift; shift;;
            -d|--debug)
                DEBUG_LEVEL=1
                shift;;
            -h|--help)
                show_help
                exit 0;;
            *)
                show_help && die "Unknown parameter '$1'"
        esac
    done

    debug ${INITIAL_DEBUG_LEVEL} "-- parse_parameters"
}

check_parameters() {
    debug ${DEBUG_LEVEL} "++ check_parameters ($@)"

    #[[ -z "${XXX}" && -z "${YYY}" ]] && show_help && die "XXX"

    debug ${DEBUG_LEVEL} "-- check_parameters"
}

########## Utils ##########
_create_dir() {
    debug ${DEBUG_LEVEL} "++ _create_dir ($@)"

    local _DIR=$1
    if [ ! -d "${_DIR}" ]; then
        mkdir -p "${_DIR}" || die "Failed to create new directory: ${_DIR}"
    fi

    debug ${DEBUG_LEVEL} "-- _create_dir"
}

_re_create_dir() {
    debug ${DEBUG_LEVEL} "++ _re_create_dir ($@)"

    local _DIR=$1
    if [ -d "${_DIR}" ]; then
        rm -rf "${_DIR}" || die "Failed to clean up directory: ${_DIR}"
    fi
    mkdir -p "${_DIR}" || die "Failed to create new directory: ${_DIR}"

    debug ${DEBUG_LEVEL} "-- _re_create_dir"
}

_copy() {
    debug ${DEBUG_LEVEL} "++ _copy ($@)"

    cp "$@" || die "Failed to copy $@"

    debug ${DEBUG_LEVEL} "-- _copy"
}

_move() {
    debug ${DEBUG_LEVEL} "++ _move ($@)"

    mv "$@" || die "Failed to move $@"

    debug ${DEBUG_LEVEL} "-- _move"
}

_symlink() {
    debug ${DEBUG_LEVEL} "++ _symlink ($@)"

    ln -sf "$@" || die "Failed to create symbol link: $@"

    debug ${DEBUG_LEVEL} "-- _symlink"
}

_check_binary() {
    debug ${DEBUG_LEVEL} "++ _check_binary ($@)"

    local _BIN_NAME="$1"
    local _BIN_PATH=$(command -v ${_BIN_NAME})
    [[ $? -ne 0 || -z "${_BIN_PATH}" ]] && die "Can't find ${_BIN_NAME} in PATH, ${_BIN_NAME} not installed?"
    notice "Using ${_BIN_PATH}"

    debug ${DEBUG_LEVEL} "-- _check_binary"
}

########## Start ##########
check_precondition() {
    debug ${DEBUG_LEVEL} "++ check_precondition ($@)"

    _check_binary "curl"
    _check_binary "git"
    _check_binary "vim"

    debug ${DEBUG_LEVEL} "-- check_precondition"
}

sync_repo() {
    debug ${DEBUG_LEVEL} "++ sync_repo ($@)"
    local _REPO_PATH="$1"
    local _REPO_URI="$2"
    local _REPO_BRANCH="$3"
    local _REPO_NAME="$4"

    notice "Trying to update ${_REPO_NAME}"

    if [ ! -e "${_REPO_PATH}" ]; then
        mkdir -p "${_REPO_PATH}"
        git clone -b "${_REPO_BRANCH}" "${_REPO_URI}" "${_REPO_PATH}" || die "Failed to clone ${_REPO_NAME}."
    else
        cd "${_REPO_PATH}" && git pull origin "${_REPO_BRANCH}" || die "Failed to update ${_REPO_NAME}"
    fi

    debug ${DEBUG_LEVEL} "-- sync_repo"
}

install_vim_plug() {
    debug ${DEBUG_LEVEL} "++ install_vim_plug ($@)"

    curl -fLo ~/.vim/autoload/plug.vim --create-dirs ${DEFAULT_VIM_PLUG_URL} || die "Failed to install vim-plug"

    debug ${DEBUG_LEVEL} "-- install_vim_plug"
}

_backup() {
    debug ${DEBUG_LEVEL} "++ _backup ($@)"

    [ -e "$1" ] && [ ! -L "$1" ] && _move $@

    debug ${DEBUG_LEVEL} "-- _backup"
}

backup() {
    debug ${DEBUG_LEVEL} "++ backup ($@)"

    local _TODAY=`date +%Y%m%d_%s`

    # backup bash
    _backup "${HOME}/.bashrc_my" "${HOME}/.bashrc_my.${_TODAY}"
    _backup "${HOME}/.bashrc.local.before" "${HOME}/.bashrc.local.before.${_TODAY}"

    # backup vim
    _backup "${HOME}/.vim" "${HOME}/.vim.${_TODAY}"
    _backup "${HOME}/.vimrc" "${HOME}/.vimrc.${_TODAY}"
    #_backup "${HOME}/.gvimrc" "${HOME}/.gvimrc.${_TODAY}"

    debug ${DEBUG_LEVEL} "-- backup"
}

setup_vim_plug() {
    debug ${DEBUG_LEVEL} "++ setup_vim_plug($@)"
    local _SYS_SHELL="$SHELL"
    export SHELL='/bin/sh'

    vim \
        -u "$1" \
        "+set nomore" \
        "+PlugInstall!" \
        "+PlugClean" \
        "+qall" || die "Failed to install vim plugins"

    export SHELL="${_SYS_SHELL}"

    debug ${DEBUG_LEVEL} "-- setup_vim_plug"
}

install() {
    debug ${DEBUG_LEVEL} "++ install($@)"

    install_vim_plug

    _symlink "${APP_PATH}/dotfiles/.bashrc" "${HOME}/.bashrc_my"
    _copy "${APP_PATH}/dotfiles/.bashrc.local.before" "${HOME}/.bashrc.local.before"

    _symlink "${APP_PATH}/vim/.vimrc" "${HOME}/.vimrc"
    #_symlink "${APP_PATH}/.gvimrc" "${HOME}/.gvimrc"

    #setup_vim_plug ${APP_PATH}/vim/.vimrc

    debug ${DEBUG_LEVEL} "-- install"
}

run() {
    debug ${INITIAL_DEBUG_LEVEL} "++ run ($@)"

    parse_parameters "$@"
    check_parameters

    check_precondition

    backup

    sync_repo   "${APP_PATH}" \
                "${APP_REPO}" \
                "${APP_REPO_BRANCH}" \
                "${APP_NAME}"


    install

    notice "Source ${HOME}/.bashrc_my in your ${HOME}/.bashrc"
    notice "Install vim plugins with PlugInstall and PlugClean"

    debug ${INITIAL_DEBUG_LEVEL} "-- run"
    return 0
}

stderr "Called as: $0 $*"
run "$@" && stderr "Finished: $0 $*"
