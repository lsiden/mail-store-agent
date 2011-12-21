Gem::Specification.new do |s|
  s.name        = 'mail-store-agent'
  s.version     = '0.1.0'
  s.summary     = "Tiny mail agent for extracting delivered mail messages from Mail::TestMailer"
  s.description = "Provides per-email-account sequential access to Mail::TestMailer.deliveries"
  s.authors     = ["Larry Siden, Westside Consulting LLC"]
  s.email       = 'lsiden@westside-consulting.com'
  s.files       = Dir['README.mkd'] + Dir['lib/*.rb'] + Dir['spec/*.rb']
  s.homepage    = 'http://github.com/lsiden/mail-store-agent/'
  s.licenses    = ['Creative Commons Share-Alike Unported', 'Ruby License']
  s.add_development_dependency 'mail'
end
