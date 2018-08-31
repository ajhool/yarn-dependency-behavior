# Simple repository for isolating dependency behavior for yarn Workspaces

## moduleA, moduleB, moduleC are related in the following way:
- moduleA depends on moduleB
- moduleB depends on moduleC as a devDependency
- moduleC has a small devDependency from the npm registry

## moduleD and moduleE
moduleD and moduleE are not related to A, B, or C, and they each have separate, small devDependencies. Each of those devDependencies also has a small devDependencies. These are designed to show the behavior for devDependencies of devDependencies when `yarn install --production` is used
