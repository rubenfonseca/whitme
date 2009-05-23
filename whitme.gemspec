# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{whitme}
  s.version = "1.1.0"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Ruben Fonseca"]
  s.date = %q{2009-05-23}
  s.email = %q{root@cpan.org}
  s.extra_rdoc_files = ["README.rdoc", "LICENSE"]
  s.files = ["README.rdoc", "VERSION.yml", "lib/whitme.rb", "spec/spec_helper.rb", "spec/whitme_spec.rb", "LICENSE"]
  s.has_rdoc = true
  s.homepage = %q{http://github.com/rubenfonseca/whitme}
  s.rdoc_options = ["--inline-source", "--charset=UTF-8"]
  s.require_paths = ["lib"]
  s.rubygems_version = %q{1.3.1}
  s.summary = %q{whitme is a Ruby library for the URL shortener service whit.me}

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 2

    if Gem::Version.new(Gem::RubyGemsVersion) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<json_pure>, [">= 0"])
    else
      s.add_dependency(%q<json_pure>, [">= 0"])
    end
  else
    s.add_dependency(%q<json_pure>, [">= 0"])
  end
end
