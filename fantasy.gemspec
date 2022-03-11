# frozen_string_literal: true

require_relative "lib/fantasy/version"

Gem::Specification.new do |spec|
  spec.name = "fantasy"
  spec.version = Fantasy::VERSION
  spec.authors = ["Fernando Guillen"]
  spec.email = ["fguillen.mail@gmail.com"]

  spec.summary = "Simple toolbox library and lean API to build great mini games"
  spec.description = "Simple toolbox library and lean API to build great mini games"
  spec.homepage = "https://github.com/fguillen/fantasy"
  spec.license = "MIT"
  spec.required_ruby_version = ">= 3.0.0"

  spec.metadata["allowed_push_host"] = "TODO: Set to your gem server 'https://example.com'"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = "https://github.com/fguillen/fantasy"
  spec.metadata["changelog_uri"] = "https://github.com/fguillen/fantasy/blob/main/CHANGELOG.md"

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files = Dir.chdir(File.expand_path(__dir__)) do
    `git ls-files -z`.split("\x0").reject do |f|
      (f == __FILE__) || f.match(%r{\A(?:(?:test|spec|features)/|\.(?:git|travis|circleci)|appveyor)})
    end
  end
  spec.bindir = "exe"
  spec.executables = spec.files.grep(%r{\Aexe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  # Uncomment to register a new dependency of your gem
  spec.add_dependency "gosu", "~> 1.4.1"
  spec.add_dependency "vector2d", "~> 2.2.3"

  # For more information and examples about making a new gem, checkout our
  # guide at: https://bundler.io/guides/creating_gem.html
end
