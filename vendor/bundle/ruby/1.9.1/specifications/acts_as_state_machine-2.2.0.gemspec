# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = "acts_as_state_machine"
  s.version = "2.2.0"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["RailsJedi", "Scott Barron"]
  s.date = "2010-02-14"
  s.description = "This act gives an Active Record model the ability to act as a finite state machine (FSM)."
  s.email = "railsjedi@gmail.com"
  s.extra_rdoc_files = ["README"]
  s.files = ["README"]
  s.homepage = "http://github.com/jcnetdev/acts_as_state_machine"
  s.rdoc_options = ["--main", "README"]
  s.require_paths = ["lib"]
  s.rubygems_version = "1.8.11"
  s.summary = "Allows ActiveRecord models to define states and transition actions between them"

  if s.respond_to? :specification_version then
    s.specification_version = 3

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<activerecord>, [">= 2.1"])
    else
      s.add_dependency(%q<activerecord>, [">= 2.1"])
    end
  else
    s.add_dependency(%q<activerecord>, [">= 2.1"])
  end
end
