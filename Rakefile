require "bundler/gem_tasks"
Bundler.require(:default, :test)
require 'rspec/core/rake_task'

desc "Run RSpec"
RSpec::Core::RakeTask.new(:rspec) do |t|
  t.ruby_opts = %w[-w]
end
