require 'rake'
require 'rspec/core/rake_task'
require 'puppet-lint/tasks/puppet-lint'

# See: https://github.com/rodjek/puppet-lint/issues/331
Rake::Task[:lint].clear

PuppetLint::RakeTask.new :lint do |config|
  config.ignore_paths = ["pkg/**/*.pp",
                         "templates/**/*.*",
                         "files/**/*.*",
                         "spec/**/*.*",
                         "vendor/**/*.*",
                         "vagrant/**/*.pp"]

  config.disable_checks = ["autoloader_layout"]
end

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
