# Simple repository for isolating dependency behavior for yarn Workspaces

To execute test script, download the `toTest.sh` file and execute it in a clean directory -- this script is included in the repository but needs to be executed in a parent directory because it will clone this repository 3x into three child directories.

`yarn install` works correctly
`yarn install --production` works correctly
`yarn install && yarn install --production` does NOT work correctly

## moduleA, moduleB, moduleC are related in the following way:
- moduleA depends on moduleB
- moduleB depends on moduleC as a devDependency
- moduleC has a small devDependency from the npm registry

## moduleD and moduleE (No local dependencies -- behave correctly)
- moduleD and moduleE are not related to A, B, or C
- moduleD has a devDependency (which also has a devDependency)
- moduleE has a dependency (which has a devDependency) 

## Behavior to display dependency weirdness (can also use toTest.sh script)
Clone the repo three separate times and execute different install commands, then compare the file structures:

1. git clone https://github.com/ajhool/yarn-dependency-behavior.git production-behavior
2. git clone https://github.com/ajhool/yarn-dependency-behavior.git dev-behavior
3. git clone https://github.com/ajhool/yarn-dependency-behavior.git hybrid-behavior
4. cd production-behavior && yarn install --production && cd ..
5. cd dev-behavior && yarn install && cd ..
6. cd hybrid-behavior && yarn install && yarn install --production && cd ..

Show differences in file paths (see below for output):

7. diff -rq production-behavior dev-behavior
8. diff -rq production-behavior hybrid-behavior
9. diff -rq dev-behavior hybrid-behavior

Show that dev dependencies exist in the moduleA -> moduleB -> moduleC path, even though moduleC is a devDependency of moduleB:

10. ls hybrid-behavior/packages/moduleA/node_modules/packageB/node_modules

```
Step 7 output (diff production-behavior dev-behavior) -- LOOKS CORRECT:

Only in dev-behavior/node_modules/moduleB: node_modules
Only in dev-behavior/node_modules/moduleD: node_modules
Only in dev-behavior/node_modules/moduleE: node_modules
Only in dev-behavior/packages/moduleB: node_modules
Only in dev-behavior/packages/moduleD: node_modules
Only in dev-behavior/packages/moduleE: node_modules

--------

Step 8 output (diff production-behavior hybrid-behavior) -- INCORRECT (see bolded lines; B D C only have dev dependencies):
Only in hybrid-behavior/node_modules/moduleA/node_modules/moduleB: node_modules
Only in hybrid-behavior/node_modules/moduleB: node_modules
Only in hybrid-behavior/node_modules/moduleD: node_modules
Only in hybrid-behavior/node_modules/moduleE: node_modules
Only in hybrid-behavior/packages/moduleA/node_modules/moduleB: node_modules [INCORRECT -- moduleB only has devDependencies & node_modules is NOT EMPTY -- hybrid-behavior should only have production dependencies]
Only in hybrid-behavior/packages/moduleB: node_modules [looks incorrect but node_modules is EMPTY, so it's okay]
Only in hybrid-behavior/packages/moduleD: node_modules [looks incorrect but node_modules is EMPTY so it's okay]
Only in hybrid-behavior/packages/moduleE: node_modules [looks incorrect but node_modules is EMPTY so it's okay]

--------

Step 9 output (diff dev-behavior hybrid-behavior) -- LOOKS INCORRECT
Only in hybrid-behavior/node_modules/moduleA/node_modules/moduleB: node_modules [INCORRECT -- moduleB only has devDependencies & node_modules is NOT EMPTY -- hybrid-behavior should only have production dependencies]
Only in dev-behavior/node_modules/moduleB/node_modules: .bin
Only in dev-behavior/node_modules/moduleB/node_modules: array-last
Only in dev-behavior/node_modules/moduleB/node_modules: is-number
Only in dev-behavior/node_modules/moduleB/node_modules: moduleC
Only in dev-behavior/node_modules/moduleD/node_modules: .bin
Only in dev-behavior/node_modules/moduleD/node_modules: parse-ms
Only in dev-behavior/node_modules/moduleD/node_modules: pretty-ms
Only in dev-behavior/node_modules/moduleE/node_modules: .bin
Only in dev-behavior/node_modules/moduleE/node_modules: is-sorted
Only in hybrid-behavior/packages/moduleA/node_modules/moduleB: node_modules [INCORRECT -- moduleB only has devDependencies & node_modules is NOT EMPTY -- hybrid-behavior should only have production dependencies]
Only in dev-behavior/packages/moduleB/node_modules: .bin
Only in dev-behavior/packages/moduleB/node_modules: array-last
Only in dev-behavior/packages/moduleB/node_modules: is-number
Only in dev-behavior/packages/moduleB/node_modules: moduleC
Only in dev-behavior/packages/moduleD/node_modules: .bin
Only in dev-behavior/packages/moduleD/node_modules: parse-ms
Only in dev-behavior/packages/moduleD/node_modules: pretty-ms
Only in dev-behavior/packages/moduleE/node_modules: .bin
Only in dev-behavior/packages/moduleE/node_modules: is-sorted
```

The behavior indicates that the first-order exclusion of dev dependencies works correctly, but something seems to go wrong when moduleA depends on a local moduleB and moduleB devDepends on a local moduleC -- the devDependencies are not excluded.
