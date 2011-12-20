require 'rubygems'
require 'rspec'

require File.join(File.dirname(__FILE__), %w[ .. lib testmailstore ])

describe TestMailStore do

  it 'is an instance of Array' do
    TestMailStore.is_a? Array
  end

  it 'can be given as argument to Mail::TestMailer#deliveries=()' do
    pending
  end

  it 'can return next e-mail for any given address' do
    pending
  end
end
