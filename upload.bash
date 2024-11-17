#!/bin/bash

cd RDWP-exe.jsexe
rm -rf .git
git init
git branch -m main
echo '.DS_Store' > .gitignore
git remote add origin git@github.com:aidatorajiro/RDWP-dist
git add .
git commit -m 'Initial commit'
git push --force origin main