lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'ruby-ogre/version'

Gem::Specification.new do |gem|
  gem.name          = "ruby-ogre"
  gem.version       = Ruby::Ogre::VERSION
  gem.authors       = ["abexsoft"]
  gem.email         = ["abexsoft@gmail.com"]
  gem.description   = %q{Ruby bindings for Ogre. Note that this ruby-ogre gem downloads a real ruby-ogre gem from bitbucket site and then installs it.}
  gem.summary       = gem.description
  gem.homepage      = "https://github.com/abexsoft/ruby-ogre"
  gem.platform      = Gem::Platform::CURRENT

  gem.files         = Dir['Rakefile',
                          'ruby-ogre-push.gemspec',
                         ]

  gem.extensions    = ['Rakefile']
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ["lib"]

  gem.add_dependency 'ruby-ois'
end
