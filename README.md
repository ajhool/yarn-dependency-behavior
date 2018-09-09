# Simple repository for isolating dependency behavior for yarn Workspaces

## moduleA, moduleB, moduleC are related in the following way:
- moduleA depends on moduleB
- moduleB depends on moduleC as a devDependency
- moduleC has a small devDependency from the npm registry

## moduleD and moduleE
moduleD and moduleE are not related to A, B, or C, and they each have separate, small devDependencies. Each of those devDependencies also has a small devDependencies. These are designed to show the behavior for devDependencies of devDependencies when `yarn install --production` is used

## Behavior to display dependency weirdness
goal: clone the repo three separate times and execute different install commands, then compare the file structures:

1. git clone https://github.com/ajhool/yarn-dependency-behavior.git production-behavior
2. git clone https://github.com/ajhool/yarn-dependency-behavior.git dev-behavior
3. git clone https://github.com/ajhool/yarn-dependency-behavior.git hybrid-behavior
4. cd production-behavior && yarn install --production && cd ..
5. cd dev-behavior && yarn install && cd ..
6. cd hybrid-behavior && yarn install && yarn install --production && cd ..
7. diff -rq production-behavior dev-behavior
8. diff -rq production-behavior hybrid-behavior
9. diff -rq dev-behavior hybrid-behavior

