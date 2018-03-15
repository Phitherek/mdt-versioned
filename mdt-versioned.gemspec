require_relative './lib/mdt/version'

Gem::Specification.new do |s|
  s.name = 'mdt-versioned'
  s.version = MDT::Versioned::VERSION
  s.date = '2018-03-15'
  s.summary = 'MDT Versioned module'
  s.description = 'A module that implements versioned releases deployment for MDT'
  s.authors = ['Phitherek_']
  s.email = ['phitherek@gmail.com']
  s.files = Dir['lib/**/*.rb']
  s.homepage = 'https://github.com/Phitherek/mdt-versioned'
  s.license = 'MIT'
  s.extra_rdoc_files = ['README.md']
  s.rdoc_options << '--title' << 'MDT Simple module' << '--main' << 'README.md' << '--line-numbers'
  s.metadata = {
      'documentation_uri' => 'http://www.rubydoc.info/github/Phitherek/mdt-versioned',
      'source_code_uri' => 'https://github.com/Phitherek/mdt-versioned'
  }
  s.add_runtime_dependency 'mdt-core', '~> 0.1'
  s.add_development_dependency 'rspec', '~> 3.7'
end
