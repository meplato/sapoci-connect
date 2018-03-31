# encoding: utf-8

extra_rdoc_files = ['CHANGELOG.md', 'LICENSE', 'README.md']

Gem::Specification.new do |s|
  s.name = 'sapoci-connect'
  s.version = '0.1.14'
  s.date = "2018-03-30"
  s.required_rubygems_version = Gem::Requirement.new(">= 1.3.6") if s.respond_to? :required_rubygems_version=
  s.authors = ['Oliver Eilhard']
  s.description = %q{HTTP client library for working with SAP OCI compliant servers.}
  s.summary = %q{The library builds on the sapoci gem and adds working with remotes, parsing its results etc.}
  s.license = "MIT"
  s.email = ['oliver.eilhard@gmail.com']
  s.extra_rdoc_files = extra_rdoc_files
  s.homepage = 'http://github.com/meplato/sapoci-connect'
  s.rdoc_options = ['--charset=UTF-8']
  s.require_paths = ['lib']
  s.executables = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.files = `git ls-files -- {bin,lib,spec}/*`.split("\n") + extra_rdoc_files
  s.test_files = `git ls-files -- {spec}/*`.split("\n")

  s.add_dependency 'faraday', ['~> 0.8', '< 0.9']
  #s.add_dependency 'cookiejar', '>= 0.3.0'
  #s.add_dependency 'faraday_middleware', '>= 0.8.7'
  #s.add_dependency 'em-synchrony', '~> 1.0.0'
  #s.add_dependency 'em-http-request', '~> 1.0.0'
  #s.add_dependency 'typhoeus', '>= 0.2.4'
  s.add_dependency 'rack', ['~> 1.2', '< 2']
  s.add_dependency 'sapoci', '~> 0.1', '>= 0.1.9'
  s.add_dependency("nokogiri", "~> 1.5", '< 1.6')
  s.add_development_dependency("bundler", "~> 1.2")
  s.add_development_dependency("rdoc", "~> 3.12", ">= 3.12.1")
  s.add_development_dependency("rake", "~> 10.1")
  s.add_development_dependency("sinatra", "~> 1.3", '< 1.4')
end
