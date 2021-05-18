# encoding: utf-8

extra_rdoc_files = ['CHANGELOG.md', 'LICENSE', 'README.md']

Gem::Specification.new do |s|
  s.name = 'sapoci-connect'
  s.version = '0.5.1'
  s.summary = %q{The library builds on the sapoci gem and adds working with remotes, parsing its results etc.}
  s.description = %q{HTTP client library for working with SAP OCI compliant servers.}
  s.authors = ['Oliver Eilhard']
  s.email = ['oliver.eilhard@gmail.com']
  s.license = "MIT"
  s.extra_rdoc_files = extra_rdoc_files
  s.homepage = 'http://github.com/meplato/sapoci-connect'
  s.rdoc_options = ['--charset=UTF-8']
  s.required_ruby_version = '>= 2.6'
  s.require_paths = ['lib']
  s.executables = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.files = `git ls-files -- {bin,lib,spec}/*`.split("\n") + extra_rdoc_files
  s.test_files = `git ls-files -- {spec}/*`.split("\n")

  s.add_dependency 'faraday', '~> 1.4.1'
  s.add_dependency 'faraday_middleware', '~> 1.0.0'
  s.add_dependency 'rack', '~> 2.0', '>= 2.0.9'
  s.add_dependency 'sapoci', '~> 0.5.2'
  s.add_dependency 'webrick', '~> 1.6.1'
  s.add_development_dependency("bundler", "~> 2.2.17")
  s.add_development_dependency("rdoc", "~> 6.3.1")
  s.add_development_dependency("rake", "~> 13.0.3")
  s.add_development_dependency("sinatra", '~> 2.1')
  s.add_development_dependency("sinatra-contrib", '~> 2.1')
end
