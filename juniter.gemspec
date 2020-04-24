require_relative 'lib/juniter/version'

Gem::Specification.new do |spec|
  spec.name          = "juniter"
  spec.version       = Juniter::VERSION
  spec.authors       = ["Matt Kobs"]
  spec.email         = ["matt@kobsy.net"]

  spec.summary       = %q{Parse and interact with JUnit XML files as Ruby objects}
  spec.homepage      = "https://github.com/kobsy/juniter"
  spec.license       = "MIT"
  spec.required_ruby_version = Gem::Requirement.new(">= 2.3.0")

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = "https://github.com/kobsy/juniter"

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files         = Dir.chdir(File.expand_path('..', __FILE__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_dependency "ox"

  spec.add_development_dependency "bundler"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "pry"
  spec.add_development_dependency "shoulda-context"
  spec.add_development_dependency "minitest-stub-const"
end
