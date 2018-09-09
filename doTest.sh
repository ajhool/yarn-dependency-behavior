#!/bin/bash

# WARNING: This script is included in the repository, but it must be executed from a parent directory because it clones this repository three times with three different install patterns.

git clone https://github.com/ajhool/yarn-dependency-behavior.git production-behavior &&
git clone https://github.com/ajhool/yarn-dependency-behavior.git dev-behavior &&
git clone https://github.com/ajhool/yarn-dependency-behavior.git hybrid-behavior &&

cd production-behavior && yarn install --production --force && cd ..
cd dev-behavior && yarn install --force && cd ..
cd hybrid-behavior && yarn install && yarn install --production --force && cd ..

diff -rq production-behavior dev-behavior
diff -rq production-behavior hybrid-behavior
diff -rq dev-behavior hybrid-behavior

ls hybrid-behavior/packages/moduleA/node_modules/moduleB/node_modules
