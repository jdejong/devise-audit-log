
lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "devise/audit-log/version"

Gem::Specification.new do |spec|
  spec.name          = "devise-audit-log"
  spec.version       = Devise::AuditLog::VERSION
  spec.authors       = ["Jonathan De Jong"]
  spec.email         = ["jonathan@helloglobo.com"]

  spec.summary       = %q{This GEM provides a log of all authentication requests in Warden and Devise.}
  spec.description   = %q{This GEM provides a log of all authentication requests in Warden and Devise. Requires devise-eventable for simple events to be monitored by this GEM.}
  spec.homepage      = "https://github.com/jdejong/devise-audit-log"
  spec.license       = "MIT"

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files         = Dir.chdir(File.expand_path('..', __FILE__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_dependency "devise", "~> 4"
  spec.add_dependency "devise-eventable", ">= 0.1.1", "<= 1"

  spec.add_development_dependency "bundler", "~> 1.16"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", "~> 3.0"
end
