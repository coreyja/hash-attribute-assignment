require 'hash_attribute_assignment'
require 'hash_attribute_assignment/version'

Gem::Specification.new do |s|
  s.name          = 'hash_attribute_assigment'
  s.summary       = 'Instantiate objects with a hash of instance variables'
  s.version       = HashAttributeAssignment::VERSION
  s.author        = 'Corey Alexander'
  s.email         = 'coreyja@gmail.com'
  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map { |f| File.basename(f) }
  s.require_paths = ['lib']
  s.license       = 'MIT'
  s.homepage      = 'https://github.com/coreyja/hash_attribute_assignment'

  s.required_ruby_version = '>= 2.1.0'
end
