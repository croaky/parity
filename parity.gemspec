require File.expand_path("../lib/parity/version", __FILE__)

Gem::Specification.new do |spec|
  spec.authors = ["Dan Croak"]

  spec.description = <<-eos
    Development/staging/production parity makes it easier for
    those who write the code to deploy the code.
  eos

  spec.email = ["dan@thoughtbot.com"]
  spec.executables = ["development", "staging", "production"]
  spec.files = `git ls-files -- lib/* README.md`.split("\n")
  spec.homepage = "https://github.com/croaky/parity"
  spec.license = "MIT"
  spec.name = "parity"
  spec.require_paths = ["lib"]
  spec.summary = "Shell commands for development, staging, and production parity."
  spec.version = Parity::VERSION
end
