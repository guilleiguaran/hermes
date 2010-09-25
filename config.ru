require "rubygems"
require "bundler"
ENV["RACK_ENV"] ||= "development" unless ENV["RACK_ENV"]
Bundler.require(:default, ENV["RACK_ENV"].to_sym)

require "hermes"


run Hermes.new