#!/bin/bash

for gitprojpath in `find . -type d -name .git | sed "s/\/\.git//"`; do
  pushd . >/dev/null

  cd $gitprojpath

  # echo $gitprojpath

  isdirty=$(git status -s | grep "^.*")
  if [ -n "$isdirty" ]; then
    if [ "$1" = "-v" ]; then
      echo
      echo "DIRTY:" $gitprojpath
      git status -s
    else
      echo "DIRTY:" $gitprojpath
    fi
  fi

  branch_name=$(git symbolic-ref -q HEAD)
  branch_name=${branch_name##refs/heads/}
  if [ -n "$branch_name" ]; then
      remote=$(git config --get branch.${branch_name}.remote)
      remote_branch=$(git config --get branch.${branch_name}.merge)

      # echo "remote=$remote;remote_branch=$remote_branch"

      if [[ -n "$remote" && -n "$remote_branch" ]]; then
          has_change=$(git log --pretty=format:'%h %ad | %s [%an] %d' --date=short "$remote/$remote_branch"..HEAD 2>/dev/null | grep "^.*")
          if [ -n "$has_change" ]; then
            if [ "$1" = "-v" ]; then
              echo
              echo "UNMERGED-COMMITS:" $gitprojpath
              git log --pretty=format:'%h %ad | %s [%an] %d' --date=short "$remote/$remote_branch"..HEAD 2>/dev/null
            else
              echo "UNMERGED-COMMITS:" $gitprojpath
            fi
          fi
      fi
  fi

  popd >/dev/null
done
