
class TestMailStore < Array

  def initialize(filename)
    @queues = {}
    @next_unsorted = 0  # index of next unsorted e-mail
  end

  def accounts
    self.sort!
    return @queues.keys
  end

  def get(address)
    self.sort!
    return @queues[address] ? @queues[address].shift : nil
  end

  private
  def sort!
    self[@next_unsorted..self.length].each do |email|
      email.destinations.each do |dest|
        @queues[dest] = [] if @queues[dest].nil?
        @queues[dest].push email
      end
    end
    @next_unsorted = self.length
  end

end
