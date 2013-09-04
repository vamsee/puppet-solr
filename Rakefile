require 'rake'
require 'rspec/core/rake_task'
require 'puppet-lint/tasks/puppet-lint'
PuppetLint.configuration.ignore_paths = ["pkg/**/*.pp",
                                         "templates/**/*.*",
                                         "files/**/*.*",
                                         "spec/**/*.*",
                                         "vendor/**/*.*",
                                         "vagrant/**/*.pp"]

RSpec::Core::RakeTask.new(:spec) do |t|
  t.pattern = FileList['spec/*/*_spec.rb'].exclude('spec/system/*_spec.rb')
end

RSpec::Core::RakeTask.new("spec:system") do |t|
  t.pattern = 'spec/system/*_spec.rb'
end

RSpec::Core::RakeTask.new("spec:all") do |t|
  t.pattern = 'spec/*/*_spec.rb'
end

task :default => ["spec", "lint"]
