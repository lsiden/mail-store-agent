require 'rubygems'
require 'rspec'
require 'mail'

require File.join(File.dirname(__FILE__), %w[ .. lib testmailstore ])

describe TestMailStore do
  before(:all) do
    Mail.defaults do
      delivery_method :test # don't use '='!
      Mail::TestMailer.deliveries = TestMailStore.new
    end
  end

  it 'is an instance of Array' do
    TestMailStore.is_a? Array
  end

  it 'can be given as argument to Mail::TestMailer#deliveries=()' do
    Mail::TestMailer.deliveries.is_a? TestMailStore
    Mail::TestMailer.deliveries.should have(0).messages

  end

  it 'can store mail' do
    mail = Mail.deliver do
      to 'lsiden@gmail.com'
      from 'lsiden@gmail.com'
      subject 'just testing'
      body 'get this?'
    end
    mail.should be_instance_of Mail::Message
    mail.perform_deliveries.should == true
    mail.errors.each {|e| puts e}
    Mail::TestMailer.deliveries.should have(1).message

    Mail.deliver do
      to 'lsiden@gmail.com'
      from 'lsiden@gmail.com'
      subject 'still testing'
      body 'get this, too?'
    end
    Mail::TestMailer.deliveries.should have(2).messages

    Mail.deliver do
      to 'jordan@foo.bar'
      from 'lsiden@gmail.com'
      subject 'testing now'
      body 'get this?'
    end
    Mail::TestMailer.deliveries.should have(3).messages

    mail = Mail.deliver do
      to 'lsiden@gmail.com'
      from 'lsiden@gmail.com'
      subject 'keep on testing'
      body 'what about this?'
    end
    Mail::TestMailer.deliveries.should have(4).messages
  end

  it 'can return next e-mail for any given address' do
    mail = Mail::TestMailer.deliveries.get('jordan@foo.bar')
    mail.should be_kind_of Mail::Message
    mail.to[0].should == 'jordan@foo.bar'
    mail.subject.should == 'testing now'
  end

  it 'returns nil if there is no more mail for address' do
    Mail::TestMailer.deliveries.get('jordan@foo.bar').should be_nil
  end

  it 'returns nil if given a non-existent address' do
    Mail::TestMailer.deliveries.get('blah@foo.bar').should be_nil
  end

  it 'returns emails in order' do
    Mail::TestMailer.deliveries.get('lsiden@gmail.com').subject.should == 'just testing'
    Mail::TestMailer.deliveries.get('lsiden@gmail.com').subject.should == 'still testing'
    Mail::TestMailer.deliveries.get('lsiden@gmail.com').subject.should == 'keep on testing'
    Mail::TestMailer.deliveries.get('lsiden@gmail.com').should be_nil
  end

  it 'does not delete the mail' do
    Mail::TestMailer.deliveries.should have(4).entries
  end
end
