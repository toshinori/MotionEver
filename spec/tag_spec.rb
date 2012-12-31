describe 'Tag Model' do

  describe '.name' do
    it 'should not be empty' do
      Tag.file_name.should.not.empty
    end
  end

  describe '.truncate' do
    before do
      Tag.truncate
    end
    it 'file not exist' do
      File.exist?(Tag.path).should.not.equal true
    end
  end

end
