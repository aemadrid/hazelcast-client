#require 'bundler'
#Bundler::GemHelper.install_tasks

require 'rubygems'
require 'rake'
require 'rake/testtask'
require 'rake/rdoctask'

begin
  require 'jeweler'
  Jeweler::Tasks.new do |gem|
    gem.name              = "hazelcast-client"
    gem.authors           = ["Adrian Madrid"]
    gem.email             = ["aemadrid@gmail.com"]
    gem.homepage          = ""
    gem.summary           = %q{Connecting to a Hazelcast Cluster has never been easier!}
    gem.description       = %q{Hazelcast::Client is a little gem that wraps the Java Hazelcast Client library into a more comfortable JRuby package.}
    gem.platform          = "jruby"

    gem.rubyforge_project = "hazelcast-client"

    gem.files             = FileList['bin/*', 'lib/**/*.rb', 'jars/**/*', 'test/**/*.rb', '[A-Z]*'].to_a
    gem.test_files        = Dir["test/test*.rb"]
#    gem.executables       = `git ls-files -- bin/*`.split("\n").map { |f| File.basename(f) }
    gem.executables       = FileList['bin/*'].map { |f| File.basename(f) }
    gem.require_paths     = ["lib"]

    gem.add_dependency "hazelcast-jars", "1.9.1"
  end
  Jeweler::GemcutterTasks.new
rescue LoadError
  puts "Jeweler (or a dependency) not available. Install it with: gem install jeweler"
end

Rake::TestTask.new :test do |t|
  t.libs << "lib"
  t.test_files = FileList["test/**/test_*.rb"]
end

task :test => :check_dependencies

task :default => :test

begin
  require 'rcov/rcovtask'
  Rcov::RcovTask.new do |spec|
    spec.libs << 'spec'
    spec.pattern = 'spec/**/*_spec.rb'
    spec.verbose = true
  end
rescue LoadError
  task :rcov do
    abort "RCov is not available. In order to run rcov, you must: sudo gem install spicycode-rcov"
  end
end

require 'rake/rdoctask'
Rake::RDocTask.new do |rdoc|
  version       = File.exist?('VERSION') ? File.read('VERSION') : ""

  rdoc.rdoc_dir = 'rdoc'
  rdoc.title    = "rubyhaze #{version}"
  rdoc.rdoc_files.include('README*')
  rdoc.rdoc_files.include('lib/**/*.rb')
end
