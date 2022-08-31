# solidusio/extensions CircleCI Orb

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
  run-specs-with-sqlite:
    executor: solidusio_extensions/sqlite
    steps:
      - solidusio_extensions/run-tests
  lint-code:
    executor: solidusio_extensions/sqlite-memory
    steps:
      - solidusio_extensions/lint-code

workflows:
  "Run specs on supported Solidus versions":
    jobs:
      - run-specs-with-postgres
      - run-specs-with-mysql
      - run-specs-with-sqlite
      - lint-code

  "Weekly run specs against master":
    triggers:
      - schedule:
          cron: "0 0 * * 4" # every Thursday
          filters:
            branches:
              only:
                - master
    jobs:
      - run-specs-with-sqlite
```

Be sure to also enable building the project on CircleCI, otherwise it won't
do anything.

### Test Results (RSpec)

To enable CircleCI Test Results be sure to include `rspec_junit_formatter` in your gemspec:

    spec.add_development_dependency 'rspec_junit_formatter'

And to properly setup the RSpec Rake task to generate the results XML output:

```rb
RSpec::Core::RakeTask.new(:specs) do |t|
  # Ref: https://circleci.com/docs/2.0/configuration-reference/#store_test_results
  if ENV['TEST_RESULTS_PATH']
    t.rspec_opts =
      "--format progress " \
      "--format RspecJunitFormatter --out #{ENV['TEST_RESULTS_PATH']}"
  end
end
```

## Contributing

We accept Pull Requests on this repository. Any kind of contribution is welcome.

## Publishing the solidusio/extensions Orb

The [orb-tools Orb](https://github.com/CircleCI-Public/orb-tools-orb) is used
for publishing development and production versions of this Orb.

PRs will create a development release of the Orb, while creating GitHub tags and releases
will trigger publishing a new version in the Orb registry.

### Publish a development version from the CLI

Reference: https://circleci.com/docs/2.0/creating-orbs/#using-the-cli-to-publish-orbs

1. Setup the CircleCI CLI (https://circleci.com/docs/2.0/creating-orbs/#step-1---set-up-the-circleci-cli)
2. Build a one-file version of the orb with `circleci config pack src/ > build/orb.yml`
3. Publish the ORB with a development version (e.g. one linked to your current PR): `circleci orb publish build/orb.yml solidusio/extensions@dev:pr-123`
4. Test the ORB on a project updating the version `solidusio_extensions: solidusio/extensions@dev:pr-123`

## License

The Orb is available as open source under the terms of the MIT License
as specified in the [Orbs Registry Licence](https://circleci.com/orbs/registry/licensing).
