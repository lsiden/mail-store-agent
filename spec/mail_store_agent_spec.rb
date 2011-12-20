require 'rubygems'
require 'rspec'
require 'mail'

require File.join(File.dirname(__FILE__), %w[ .. lib mail_store_agent ])

describe MailStoreAgent do
  before(:all) do
    Mail.defaults do
      delivery_method :test # don't use '='!
      Mail::TestMailer.deliveries = MailStoreAgent.new
    end
  end

  it 'is an instance of Array' do
    MailStoreAgent.is_a? Array
  end

  it 'can be given as argument to Mail::TestMailer#deliveries=()' do
    Mail::TestMailer.deliveries.is_a? MailStoreAgent
    Mail::TestMailer.deliveries.should have(0).messages

  end

  it 'can store mail' do
    mail = Mail.deliver do
      to 'tarzan@jungle.com'
      from 'tarzan@jungle.com'
      subject 'just testing'
      body 'get this?'
    end
    mail.should be_instance_of Mail::Message
    mail.perform_deliveries.should == true
    mail.errors.each {|e| puts e}
    Mail::TestMailer.deliveries.should have(1).message

    Mail.deliver do
      to 'tarzan@jungle.com'
      from 'tarzan@jungle.com'
      subject 'still testing'
      body 'get this, too?'
    end

    Mail.deliver do
      to 'jane@jungle.com'
      from 'tarzan@jungle.com'
      subject 'testing now'
      body 'get this?'
    end

    mail = Mail.deliver do
      to 'tarzan@jungle.com'
      from 'tarzan@jungle.com'
      subject 'keep on testing'
      body 'what about this?'
    end
    Mail::TestMailer.deliveries.should have(4).messages
  end

  it 'knows what accounts have been sent mail' do
    Mail::TestMailer.deliveries.accounts == ['tarzan@jungle.com', 'jane@jungle.com']
  end

  it 'can return next e-mail for any given address' do
    mail = Mail::TestMailer.deliveries.get('jane@jungle.com')
    mail.should be_kind_of Mail::Message
    mail.to[0].should == 'jane@jungle.com'
    mail.subject.should == 'testing now'
  end

  it 'returns nil if there is no more mail for address' do
    Mail::TestMailer.deliveries.get('jane@jungle.com').should be_nil
  end

  it 'returns nil if given a non-existent address' do
    Mail::TestMailer.deliveries.get('blah@foo.bar').should be_nil
  end

  it 'returns emails in order' do
    Mail::TestMailer.deliveries.get('tarzan@jungle.com').subject.should == 'just testing'
    Mail::TestMailer.deliveries.get('tarzan@jungle.com').subject.should == 'still testing'
    Mail::TestMailer.deliveries.get('tarzan@jungle.com').subject.should == 'keep on testing'
    Mail::TestMailer.deliveries.get('tarzan@jungle.com').should be_nil
  end

  it 'does not delete the mail' do
    Mail::TestMailer.deliveries.should have(4).entries
  end

  it 'acts like Array and ignores contents that are not instances of Mail::Message' do
    Mail::TestMailer.deliveries.push :foo
    Mail::TestMailer.deliveries.push 'baz'
    Mail::TestMailer.deliveries.push Object.new
    Mail::TestMailer.deliveries.accounts == ['tarzan@jungle.com', 'jane@jungle.com']
    Mail::TestMailer.deliveries.get('tarzan@jungle.com').should be_nil
    Mail::TestMailer.deliveries.should have(7).items
  end
end
