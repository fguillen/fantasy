# frozen_string_literal: true

ENV["environment"] = "test"
ENV["debug"] = "no-active"

$LOAD_PATH.unshift File.expand_path("../lib", __dir__)
require "fantasy"

require "minitest/autorun"
require "mocha/minitest"
