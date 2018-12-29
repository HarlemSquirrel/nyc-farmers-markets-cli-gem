# frozen_string_literal: true

require 'webmock/rspec'

# Write cache to separate location from dev/production
OpenURI::Cache.cache_path = 'tmp/open-uri'

WebMock.disable_net_connect!(allow_localhost: true)
