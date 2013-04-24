$:.unshift File.join(File.dirname(__FILE__), *%w[.. lib])

require "rspec"
require "her"

# Require everything in `spec/support`
Dir[File.expand_path('../../spec/support/**/*.rb', __FILE__)].map(&method(:require))

RSpec.configure do |config|
  config.include Her::Testing::Macros::ModelMacros
  config.include Her::Testing::Macros::RequestMacros

  config.before :each do
    @spawned_models = []
  end

  config.after :each do
    clear_spawned_models
  end
end
