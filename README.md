This repository contains the source code of the CircleCI Orbs that we can
use on all Solidus extensions.

A [CirlceCI Orb](https://circleci.com/docs/2.0/orb-intro/) is a sharable
package of CircleCI configuration elements. We will use it to share some
of the configuration that are common to all extensions and change frequently.
In this way, we will have a single thing to change where we need to spread
new configuration across Solidus extensions, for example when a new version
of Solidus is released.

This Orb is published in the CircleCI Orbs registry at the following address:

https://circleci.com/orbs/registry/orb/solidusio/extensions

## Usage

Add the following code into the extension's `.circleci/config.yml`:

```yml
version: 2.1

orbs:
  # Always take the latest version of the Orb, this allows us to
  # run specs against Solidus supported versions only without the need
  # to change this configuration every time a Solidus version is released
  # or goes EOL.
  solidusio_extensions: solidusio/extensions@volatile

jobs:
  run-specs-with-postgres:
    executor: solidusio_extensions/postgres
    steps:
      - solidusio_extensions/run-tests
  run-specs-with-mysql:
    executor: solidusio_extensions/mysql
    steps:
      - solidusio_extensions/run-tests

workflows:
  "Run specs on supported Solidus versions":
    jobs:
      - run-specs-with-postgres
      - run-specs-with-mysql
  "Weekly run specs against master":
    triggers:
      - schedule:
          cron: "0 0 * * 4" # every Thursday
          filters:
            branches:
              only:
                - master
    jobs:
      - run-specs-with-postgres
      - run-specs-with-mysql
```

Be sure to also enable building the project on CircleCI, otherwise it won't
do anything.

## Contributing

We accept Pull Requests on this repository. Any kind of contrubution is welcome.

## Publishing the solidusio/extensions Orb

The [orb-tools Orb](https://github.com/CircleCI-Public/orb-tools-orb) is used
for publishing development and production versions of this Orb.

PRs will create a development release of the Orb, while merging in master will
release a new version of the Orb, using semver and following these rule:

> Modifications to jobs or commands trigger a potential major release;
> modifications to executors, examples, or @orb.yml trigger a minor release;
> modifications to the orb’s config.yml file trigger a patch release;

## License

The Orb is available as open source under the terms of the MIT License
as specified in the [Orbs Registry Licence](https://circleci.com/orbs/registry/licensing).
