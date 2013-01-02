describe 'NoteSender' do
  describe '.instance' do
    before do
      @note_sender = NoteSender.instance
    end
    it 'single instance' do
      @note_sender.equal?(NoteSender.instance).should.equal true
    end
  end

  describe '.queue_instance' do
    before do
      @queue = NoteSender.queue_instance
    end
    it 'single instance' do
      @queue.equal?(NoteSender.queue_instance).should.equal true
    end
  end

end
