require 'rake/gempackagetask'
require 'methodchain'

spec = Gem::Specification.new do |s|
  s.name = 'methodchain'
  s.version = MethodChain::VERSION
  s.platform = Gem::Platform::RUBY
  s.summary = "Replace methods in an existing class but keep super"
  s.homepage = "http://github.com/zimbatm/methodchain"
  s.description = "Like alias_method_chain (ActiveSupport) but with super support."
  s.authors = ["zimbatm"]
  s.email = "zimbatm@oree.ch"
  s.has_rdoc = true
  s.files = FileList['README.rdoc', 'Rakefile', 'lib/*', 'test/*', 'task/*', 'example/*']
  s.test_files = FileList['test/spec*.rb']
end

Rake::GemPackageTask.new(spec) do |pkg|
  pkg.package_dir = "build"
#  pkg.need_zip = true
#  pkg.need_tar = true
end
task :gem => "gem:spec"

namespace :gem do

  spec_name = "methodchain.gemspec"
  desc "Updates the #{spec_name} file if VERSION has changed"
  task :spec do
    if !File.exist?(spec_name) ||
      eval(File.read(spec_name)).version.to_s != MethodChain::VERSION
      File.open(spec_name, 'w') do |f|
        f.write(spec.to_ruby)
      end
      STDOUT.puts "*** Gem specification updated ***"
    end
  end
end

