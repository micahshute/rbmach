require_relative 'lib/rbmach/version'

Gem::Specification.new do |spec|
  spec.name          = "rbmach"
  spec.version       = Rbmach::VERSION
  spec.authors       = ["Micah Shute"]
  spec.email         = ["micah.shute@gmail.com"]

  spec.summary       = %q{Write a short summary, because RubyGems requires one.}
  # spec.description   = %q{TODO: Write a longer description or delete this line.}
  spec.homepage      = "https://www.github.com/micahshute/rbmach"
  spec.license       = "MIT"
  spec.required_ruby_version = Gem::Requirement.new(">= 2.3.0")

  # spec.metadata["allowed_push_host"] = "TODO: Set to 'http://mygemserver.com'"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = "https://www.github.com/micahshute/rbmach"
  spec.metadata["changelog_uri"] = "https://www.github.com/micahshute/rbmach"

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files         = Dir.chdir(File.expand_path('..', __FILE__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_dependency(:gspec)
end
