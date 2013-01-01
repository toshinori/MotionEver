describe 'Tag Model' do

  describe '.file_name' do
    it 'not empty' do
      Tag.file_name.should.not.be.empty
    end
  end

  describe '.path' do
    it 'not empty' do
      Tag.path.should.not.be.empty
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

  describe '#new' do
    before do
      @tag = Tag.new
    end
    it 'colums are empty' do
      @tag.name.should.be.nil
      @tag.guid.should.be.nil
      @tag.parentGuid.should.be.nil
      @tag.updateSequenceNum.should.be.nil
      @tag.last_used.should.be.nil
    end
    it 'not saved' do
       Tag.all.size.should.equal 0
     end
  end

  describe '#create' do
    before do
      @tag = Tag.create(name: 'hoge')
    end
    it 'saved' do
      Tag.all.size.should.not.equal 0
    end
  end

  describe '.save and load' do
    before do
      Tag.truncate
      Tag.create(name: 'hoge')
      Tag.save
      @tags = Tag.all
    end
    it 'not empty' do
      @tags.should.not.be.empty
    end
  end
end
