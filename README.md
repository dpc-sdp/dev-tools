# Dev Tools [![CircleCI](https://circleci.com/gh/dpc-sdp/dev-tools.svg?style=svg)](https://circleci.com/gh/dpc-sdp/dev-tools)
Tools used for development of Tide distribution and modules.

## Prerequisites
1. Make sure that you have latest versions of all required software installed:   
  - [Docker](https://www.docker.com/) 
  - [Pygmy](https://docs.amazee.io/local_docker_development/pygmy.html)
  - [Ahoy](https://github.com/ahoy-cli/ahoy) 
2. Make sure that all local web development services are shut down (`apache/nginx`, `mysql`, `MAMP` etc).

## Local environment setup
3. `curl https://raw.githubusercontent.com/dpc-sdp/dev-tools/master/install | bash`
4. `pygmy up`
5. `ahoy build` 

## Available `ahoy` commands
Run each command as `ahoy <command>`.
```
   build                Build or rebuild project.
   clean                Remove all build files.
   clean-full           Remove all development files.
   cli                  Start a shell inside CLI container or run a command.
   composer-merge       Merge composer files.
   doctor               Find problems with current project setup.
   down                 Stop Docker containers and remove container, images, volumes and networks.
   drush                Run drush commands in the CLI service container.
   info                 Print information about this project.
   install-dev          Install dependencies.
   install-site         Install site.   
   lint                 Lint code.
   login                Login to a website.
   logs                 Show Docker logs.
   pull                 Pull latest docker images.
   restart              Restart all stopped and running Docker containers.
   start                Start existing Docker containers.
   stop                 Stop running Docker containers.
   test-behat           Run Behat tests.
   up                   Build and start Docker containers
```

## Main ideas behind Dev Tools
- Do not add something that does not normally exist in the repos. 
  Example: Drupal module repo should not have Docker configs.
- Fetch as much of dev config as possible from Dev Tools repository.
  Caveat: CircleCI config does not support inclusions (each project must commit 
  it) or we would use a fetched version for it as well. Instead, the steps were 
  abstracted into scripts, so that the main CI configuration file does not need 
  to be changed. 
- Abstract similar functionality into steps. This will allow to apply changes at
  the larger scale without the need to modify each project.
- Run the most of the code in the containers. This is to reduce required tools 
  on the host machine.
  Caveat: due to some limitations, `jq` must be installed on the host to work on
  module projects. This may change in the future.

## Features
- Supports project (full-site) and module projects
- Provides Docker stack based on Bay
- Allows to override configuration per-project
- Simple initialisation by CURLing install script 
- Provides CI configuration
- Provides Behat configuration

## Working with module projects

Dev Tools allows to add all required tools to module and site projects.

To support adding Dev Tools for development, it was designed to be fetchable 
from a separate repository. 
The main reason is to simplify the maintenance of module projects: remove the 
overhead of maintaining the same development files in all repositories.

While it is used only for development in module projects, for site builds it is 
advised to commit Dev Tools files to enable proper integration with hosting 
services (Lagoon) - cannot be hosted on Lagoon if there are no docker files!

To be able to support both module and site build projects, a series of 
configuration variables are available.

More specifically, for module projects, to enable local development (and CI) 
the Dev Tools needs to be fetched, composer configuration needs to be merged and 
a project needs to be built. All this is handled with a single `ahoy build`
command. 
Dev Tools also supports symlinking of current module files into Drupal project 
to support development.

In order to allow this to happen, Dev Tools creates `composer.build.json` - 
config file with merged dependencies.

Then, we install a site and install current module.

To install current module, we export current directory as is and place it into a 
local composer dependency folder. Then, we provide a new location for this 
repository and require it. Since composer does not allow to symlink the files 
to the deps itself, we are working on the copy of files. Once the work is 
finished, we need to run a sync script to make these files overwrite actual 
files in the repository (this approach is very cubersome and not implemented yet, 
but it is the only one way to overcome Composer limitation).

Next, we assess if we need to install suggested packages - this is to ensure 
that optional configuration works as expected. We also enable them (as there is 
no way to specify optional packages in module files).

Finally, we install the module itself.

### FAQs
**Q: How does the visioning work and why do we have versions set to specific constraints?**
A: This is to guarantee that our modules work correctly with expected versions. 
   Otherwise - we cannot guarantee the users of the Tide project that modules 
   will work together.

**Q: How to specify custom branch for suggested module?**
A: Just add it as a normal branch constraint to a name of the module: 
```
    "suggest": {
        "dpc-sdp/tide_api:dev-ci": "Allows to use Drupal in headless mode"
    }
```

**Q: What is 'Suggested mode'?**
A: This is how we test optional configuration. Modules may specify their 
optional dependencies using 'suggest' section in `composer.json` file. The CI 
process for each module runs `build_suggest` build, where these optional modules 
are enabled. 

**Q: What is `@suggest` and `@nosuggest` tags in tests?**
A: Tagging a test with `@suggest` means that it will run only for 
*Suggested mode* (see above). 
Tagging a test with `@nosuggest` means that the test will run only in normal mode. 
Not providing a tag will run test in both modes.

## Workflow recipes

### Using Dev Tools
#### Init Dev Tools in your project
`curl https://raw.githubusercontent.com/dpc-sdp/dev-tools/master/install | bash`
or commit `dev-init.sh` to your project and execute it as `. dev-init.sh`.
This will install the latest published release of Dev Tools.

#### Override Dev Tools files in your project
1. Remove lines that point to files being overridden from `.git/info/exclude` in 
your project repository.
2. Commit required files. They will not be overridden on next Dev Tools install.

#### Force update overridden Dev Tools files in your project
`ALLOW_OVERRIDE=1 curl https://raw.githubusercontent.com/dpc-sdp/dev-tools/master/install | bash`

#### Use Dev Tools at specific commit
`GH_COMMIT=COMMIT_SHA curl https://raw.githubusercontent.com/dpc-sdp/dev-tools/master/install | bash`

### Branch-based development for module projects 
#### Use development versions of dependencies
TBD 

## Maintenance
To update Dev Tools and release a new version, a special care should be taken as 
broken Dev Tools will break all project builds.

To make a change:
1. Create a separate branch in Dev Tools repository.
2. Make your changes, commit them and make sure the CI passes.
3. Use one of the `tide_*` modules to run the build. Create a branch in that module's repository.
4. Modify `dev-init.sh` in that module and specify `GH_COMMIT` value of the commit from step 2.
5. Commit and make sure that the build passes.
6. If the build passes, merge the Dev Tools branch to `master` and make a release.
7. Remove the temporary branch in `tide_*` module from Step 3. 
