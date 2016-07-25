# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'anyflake/version'

Gem::Specification.new do |spec|
  spec.name          = 'anyflake'
  spec.version       = Anyflake::VERSION
  spec.authors       = ['Joshimasa KISHIMOTO']
  spec.email         = ['joshimasa.kishimoto@gmail.com']

  spec.summary       = %q{Pure ruby independent ID generator like the SnowFlake, ChiliFlake}
  spec.description   = %q{Pure ruby independent ID generator like the SnowFlake, ChiliFlake}
  spec.homepage      = 'https://github.com/jkishimoto/anyflake'
  spec.license       = 'MIT'

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_development_dependency 'bundler', '~> 1.12'
  spec.add_development_dependency 'rake'
  spec.add_development_dependency 'rspec'
end
