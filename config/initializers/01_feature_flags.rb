# frozen_string_literal: true

##
# Simple toggles which allow us to turn featurs on/off with environment
# variables. These flags are particularly useful when a feature may behave
# differently in the production environment vs. other environments e.g. because
# of load.
#
# Once a feature has proved useful and stable, the flag and configuration
# options for it should be removed.
#
module FeatureFlags
  class StoreVocabSheetItemsInRailsCache
    def self.enabled?
      return false if Rails.env.test?

      ENV['FEATURE_CACHE_ITEMS_ENABLED'] == 'true'
    end

    def self.cache_timeout
      # cache for 24 hours but allow env variable to override this at runtime
      Integer(ENV.fetch('FEATURE_CACHE_ITEMS_NUM_HOURS', 24))
    end

    def self.status_msg
      "#{self} is #{enabled? ? 'enabled' : 'not enabled'} (cache timeout: #{cache_timeout} hours)"
    end
  end

  class Freelex
    def self.enabled?
      return true if Rails.env.test?

      ENV["FREELEX_ENABLED"] == 'true'
    end

    def self.timeout
      # Allow requests to take up to 20 seconds but allow env variable to override this at runtime
      Integer(ENV.fetch('FREELEX_TIMEOUT_SECONDS', enabled? ? default_timeout : 0))
    end

    def self.default_timeout
      20.seconds
    end

    def self.status_msg
      "#{self} is #{enabled? ? 'enabled' : 'not enabled'} (connection timeout: #{timeout} seconds)"
    end
  end
end

Rails.logger.info(FeatureFlags::StoreVocabSheetItemsInRailsCache.status_msg)
Rails.logger.info(FeatureFlags::Freelex.status_msg)
