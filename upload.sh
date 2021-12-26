cd RDWP-exe.jsexe
git init
echo '.DS_Store' > .gitignore
git remote add origin git@github.com:aidatorajiro/RDWP-dist
git add .
git commit -m 'Initial commit'
git push --force origin master