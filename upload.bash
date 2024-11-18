#!/bin/bash

cd RDWP-exe.jsexe
rm -rf .git
git init
git branch -m main
echo '.DS_Store' > .gitignore

if [ "$(git config credential.helper)" == "store" ]; then
  git remote add origin https://github.com/aidatorajiro/RDWP-dist
else
  git remote add origin git@github.com:aidatorajiro/RDWP-dist
fi

git add .
git commit -m 'Initial commit'
git push --force origin main
