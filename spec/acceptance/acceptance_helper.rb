require 'spec_helper'
require 'capybara/poltergeist'

Capybara.javascript_driver = :poltergeist

# Put your acceptance spec helpers inside spec/acceptance/support
Dir["#{File.dirname(__FILE__)}/support/**/*.rb"].each {|f| require f}
