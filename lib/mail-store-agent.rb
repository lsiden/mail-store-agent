
class MailStoreAgent < Array

  def initialize
    @queues = {}
    @next_unsorted = 0  # index of next unsorted e-mail
  end

  def accounts
    self.sort_mail!
    return @queues.keys
  end

  def get(address)
    self.sort_mail!
    q = @queues[address]
    return q && q.length > 0 ? q.shift : nil
  end

  # Peek at next message without removing it from queue
  def peek(address)
    self.sort_mail!
    q = @queues[address]
    return q && q.length > 0 ? q[0] : nil
  end

  protected
  def sort_mail!
    self[@next_unsorted..self.length].each do |email|
      #raise "MailStoreAgent is intended to be used as value for Mail::TestMailer.deliveries=().  See README" \
       # unless email.respond_to?(:destinations) && email.destinations.respond_to?(:each)

      if email.respond_to?(:destinations) && email.destinations.respond_to?(:each) then
        email.destinations.each do |dest|
          @queues[dest] = [] if @queues[dest].nil?
          @queues[dest].push email
        end
      end
    end
    @next_unsorted = self.length
  end

end
