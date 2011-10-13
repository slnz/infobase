# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{ruby-oci8}
  s.version = "2.0.6"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = [%q{KUBO Takehiro}]
  s.date = %q{2011-06-13}
  s.description = %q{ruby-oci8 is a ruby interface for Oracle using OCI8 API. It is available with Oracle8, Oracle8i, Oracle9i, Oracle10g and Oracle Instant Client.}
  s.email = %q{kubo@jiubao.org}
  s.extensions = [%q{ext/oci8/extconf.rb}]
  s.extra_rdoc_files = [%q{README}]
  s.files = [%q{README}, %q{ext/oci8/extconf.rb}]
  s.homepage = %q{http://ruby-oci8.rubyforge.org}
  s.rdoc_options = [%q{--main}, %q{README}]
  s.require_paths = [%q{lib}]
  s.required_ruby_version = Gem::Requirement.new(">= 1.8.0")
  s.rubyforge_project = %q{ruby-oci8}
  s.rubygems_version = %q{1.8.6}
  s.summary = %q{Ruby interface for Oracle using OCI8 API}

  if s.respond_to? :specification_version then
    s.specification_version = 2

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
    else
    end
  else
  end
end
