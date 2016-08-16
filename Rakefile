require 'rake'
require 'rspec/core/rake_task'
require 'puppet-lint/tasks/puppet-lint'

require 'puppetlabs_spec_helper/rake_tasks'

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

Rake::Task[:default].clear
task :default => ["spec", "lint"]
