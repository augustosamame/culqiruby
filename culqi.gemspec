# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'culqi/version'

Gem::Specification.new do |spec|
  spec.name          = 'culqi'
  spec.version       = Culqi::VERSION
  spec.authors       = ['Augusto Samame']
  spec.email         = ['augustosamame@gmail.com']

  spec.summary       = %q{Facilitates integration with Culqi payment processor}
  spec.description   = %q{This gem allows your rails 3/4/5 app to quickly integrate with Culqi Payment processor.
                          It handles Culqi's flavor of encryption, decryption and Culqi ticket creation.}
  spec.homepage      = 'https://github.com/augustosamame/culqiruby'
  spec.license       = 'MIT'

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = %w[ lib ]

  spec.add_development_dependency 'bundler', '~> 1.12'
  spec.add_development_dependency 'rake', '~> 10.0'
  spec.add_development_dependency 'minitest', '~> 5.0'
end
