require 'rake'
require 'rspec/core/rake_task'
require 'puppet-lint/tasks/puppet-lint'
PuppetLint.configuration.ignore_paths = ["pkg/**/*.pp",
                                         "tests/**/*.pp",
                                         "vagrant/**/*.pp"]

RSpec::Core::RakeTask.new(:spec) do |t|
  t.pattern = 'spec/*/*_spec.rb'
end
