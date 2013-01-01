describe 'EvernoteWrapper' do

  before do
     EW.init_shared_host
  end

  describe '.session' do
    it 'not nil' do
      EW.session.should.not.be.nil
    end
  end

  describe '.store' do
    it 'not nil' do
      EW.store.should.not.be.nil
    end
  end
end
