#! /bin/bash
cd doc

# gitbook install
# install the plugins and build the static site
gitbook build

cd ..

# checkout to the master branch
git checkout master

# pull the latest updates
git pull origin master


if [[ "$?" != "0" ]]; then
    exit 1
fi
# copy the static site files into the current directory.
\cp -Rf doc/_book/* .

# remove 'node_modules' and '_book' directory
# git clean -fx gitbook/node_modules
# git clean -fx gitbook/_book
rm -rf doc/_book/

# remove website css files, except last one
ccount=`ls website-* | wc -w`
if [[ "$ccount" > 1 ]];then
    allcss=($(ls website-*))
    c=0
    for css in "${allcss[@]}"; do
       let "c=c+1"
       if [[ $c -ge $ccount ]]; then
           break;
       fi
       rm -f $css
    done
fi

# add all files
git add .

# commit
git commit  -m "Update docs"

# push to the origin
git push

# checkout to the master branch
git checkout dev