require_relative 'lib/facebook_dumper/version'

Gem::Specification.new do |spec|
  spec.name          = "facebook_dumper"
  spec.version       = FacebookDumper::VERSION
  spec.authors       = ["Koichiro Eto"]
  spec.email         = ["k-eto@aist.go.jp"]

  spec.summary       = %q{Dump Facebook friends list from a web page.}
  spec.description   = %q{You can create a list of facebook friends.}
  spec.homepage      = "https://github.com/eto/facebook_dumper/"
  spec.license       = "MIT"
  spec.required_ruby_version = Gem::Requirement.new(">= 2.3.0")

  spec.metadata["allowed_push_host"] = "https://rubygems.org/"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = "https://github.com/eto/facebook_dumper/"
  spec.metadata["changelog_uri"] = "https://github.com/eto/facebook_dumper/"

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files         = Dir.chdir(File.expand_path('..', __FILE__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]
end
