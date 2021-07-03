#!/usr/bin/env bash

for d in $(find . -type d -maxdepth 1 | grep -w "\./.*"); do
  d=${d#"./"}
  git add "$d" && git commit -m "$d"
  if [ $? -eq 0 ]; then
    git push -u origin main
  fi
done
