#!/bin/sh

DIR=$(dirname "$0")

# cd $DIR/..

if [[ $(git status -s) ]]
then
    echo "The working directory is dirty. Please commit any pending changes."
    exit 1;
fi

echo "Deleting old publication"
rm -rf public
mkdir public
git worktree prune
rm -rf .git/worktrees/public/

echo "Checking out gh-pages branch into public"
git worktree add -B gh-pages public origin/gh-pages

echo "Initializing submodules"
git submodule update --init --recursive

echo "Removing existing files"
rm -rf public/*

echo "Creating CNAME for tics.101.cy domain"
echo tics.101.cy > public/CNAME

echo "Generating site"
hugo

echo "Updating gh-pages branch"
cd public && git add --all && git commit -m "Publishing to gh-pages (publish.sh)"
