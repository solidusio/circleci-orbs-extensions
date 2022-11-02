# frozen_string_literal: true

require 'solidus_core'
require 'solidus_support'

module SolidusDummyExtension
  class Engine < Rails::Engine
    include SolidusSupport::EngineExtensions

    isolate_namespace ::Spree

    engine_name 'solidus_dummy_extension'

    # use rspec for tests
    config.generators do |g|
      g.test_framework :rspec
    end
  end
end
