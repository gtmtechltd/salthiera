# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'salt_hiera/salt_hiera'

Gem::Specification.new do |gem|
  gem.name          = "salthiera"
  gem.version       = SaltHiera::SaltHiera::VERSION
  gem.description   = "Hiera like tool for use as an external pillar with SaltStack"
  gem.summary       = "Hiera like tool for use as an external pillar with SaltStack"
  gem.author        = "Geoff Meakin"
  gem.license       = "MIT"

  gem.homepage      = "http://github.com/gtmtechltd/salthiera"
  gem.files         = `git ls-files`.split($/).reject { |file| file =~ /^features.*$/ }
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ["lib"]

  gem.add_dependency('trollop', '>=2.0')
  gem.add_dependency('highline', '>=1.6.19')
end
