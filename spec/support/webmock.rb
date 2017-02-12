# frozen_string_literal: true

require 'webmock'

include WebMock::API
WebMock.disable_net_connect!(allow_localhost: true)
