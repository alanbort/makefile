# Makefile templates and examples

## Makefile patterns

Regular targets should abstract specific repository processes:

Target | Action
--- | ---
`help` |  Should print a basic help describing the main targets
`clean` | Cleans generated artifacts
`cleanall` | Deep clean, including docker system prune if docker is used, venv, etc.
`build` | Do the primary build target, this can be `dist`, `setup`, etc depending on the content of the repository 
`test` | Execute tests
`release` | Create a branch and tag for VERSION on pure code repositories, publish to package repository for packaged software
`rc` | tag release candidate for CI/CD
`releasecandidate` | alias for rc

## Vendor and Venv

* If necessary, a `vendor` or `venv` directory shall be created with its own Makefile that will configure the required additional softwaare

> `vendor` may be used for Ruby Gems, PHP Dependencies and Composer Packages, NPM Packages. `venv` is used for PyPI packages