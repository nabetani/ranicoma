lib = File.expand_path("lib", __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "ranicoma/version"

Gem::Specification.new do |spec|
  spec.name          = "ranicoma"
  spec.version       = Ranicoma::VERSION
  spec.authors       = ["Nabetani"]
  spec.email         = ["takenori@nabetani.sakura.ne.jp"]

  spec.summary       = %q{Create SVG random colorful icon.}
  spec.description   = %q{Create SVG random colorful icon.}
  spec.homepage      = "https://github.com/nabetani/ranicoma"
  spec.license       = "MIT"

  spec.metadata["homepage_uri"] = spec.homepage

  version = Ranicoma::VERSION

  spec.metadata["source_code_uri"] = "https://github.com/nabetani/ranicoma/tree/v#{version}/ranicoma"
  spec.metadata["changelog_uri"] = "https://github.com/nabetani/ranicoma/tree/v#{version}/CHANGELOG.md"

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files         = Dir.chdir(File.expand_path('..', __FILE__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 2.0"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", "~> 3.0"
end
