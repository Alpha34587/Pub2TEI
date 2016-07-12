Gem::Specification.new do |s|
  s.name        = 'pub2tei'
  s.version     = '0.0.1'
  s.date        = '2016-07-12'
  s.summary     = "a ruby wrapper for pub2tei project see : https://github.com/kermitt2/Pub2TEI"
  s.description = "a ruby wrapper for pub2tei project see : https://github.com/kermitt2/Pub2TEI"
  s.authors     = ["Simon Meoni"]
  s.email       = 'simonmeoni@aol.com'
  s.files       = Dir["lib/rb/*.rb"]
  s.required_ruby_version = '~> 2.1'
  s.requirements << 'xlstproc, xmllint, rnv'
  s.extra_rdoc_files = ['README.md']
  s.add_runtime_dependency 'thor', '0.19.1'
  s.add_runtime_dependency 'json', '2.0.1'
  s.executables << 'pub2tei'
  s.homepage    =
    'http://rubygems.org/gems/pub2tei'
    'https://github.com/Alpha34587/pub2tei'
  s.license       = 'GPL-3.0'
end
