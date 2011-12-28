# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "mail-store-agent/version"

Gem::Specification.new do |s|
  s.name        = "mail-store-agent"
  s.version     = Example::Gem::VERSION
  s.authors     = ["Larry Siden, Westside Consulting LLC"]
  s.email       = ["lsiden@westside-consulting.com"]
  s.homepage    = 'http://github.com/lsiden/mail-store-agent/'
  s.summary     = %q{
    Allows test script to access mail messages from queues by recipient.
  }
  s.description     = %q{
    require 'mail'
    require 'mail-store-agent'

    Mail.defaults do
      delivery_method :test
    end

    Mail::TestMailer.deliveries = MailStoreAgent.new

    # send some mail to someone@someplace.com, and then ...

    Mail::TestMailer.deliveries.get('someone@someplace.com').is_a? Mail::Message # or nil
  }

  s.rubyforge_project = "mail-store-agent"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]
  s.licenses    = ['Creative Commons Share-Alike Unported', 'Ruby License']

  # specify any dependencies here; for example:
  s.add_development_dependency "rspec"
  s.add_runtime_dependency "mail"
end
