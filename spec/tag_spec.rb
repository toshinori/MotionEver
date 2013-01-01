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
      Tag.save
      Tag.truncate
      Tag.load
      @tags = Tag.all
    end
    it 'file not exist' do
      File.exist?(Tag.path).should.not.equal true
    end
    it 'table is empty' do
      @tags.size.should.equal 0
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
      @tags = Tag.load
    end
    it 'not empty' do
      @tags.should.not.be.empty
    end
  end

  describe '.find_by_name' do
    before do
      Tag.truncate
      Tag.create(name: 'hoge')
      Tag.create(name: 'fuga')
      Tag.save
      Tag.load
    end

    it 'found hoge' do
      tag = Tag.find_by_name('hoge')
      tag.should.not.be.nil
      tag.name.should.equal 'hoge'
    end
  end

  describe '.order_by_num_desc' do
    before do
      Tag.truncate
      Tag.create(name: 'fuga', updateSequenceNum: 5)
      Tag.create(name: 'hoge', updateSequenceNum: 10)
      Tag.save
      Tag.load
      @tags = Tag.order_by_num_desc
    end

    it 'order by updateSequenceNum desc' do
      @tags.size.should.equal 2
      @tags[0].updateSequenceNum.should.equal 10
      @tags[1].updateSequenceNum.should.equal 5
    end
  end
end
