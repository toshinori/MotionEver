describe Tag do

  describe '.file_name' do
    it 'should not be empty' do
      Tag.file_name.should.not.be.empty
    end
  end

  describe '.path' do
    it 'should not be empty' do
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
    it 'file should not exist' do
      File.exist?(Tag.path).should.not.equal true
    end
    it 'table should be empty' do
      @tags.size.should.equal 0
    end
  end

  describe '#new' do
    before do
      @tag = Tag.new
    end
    it 'colums are empty(exclude updateSequenceNum)' do
      @tag.name.should.be.nil
      @tag.guid.should.be.nil
      @tag.parentGuid.should.be.nil
      @tag.last_used.should.be.nil
    end
    it 'should not saved' do
       Tag.all.size.should.equal 0
    end
    it 'updateSequenceNum should be 0' do
      @tag.updateSequenceNum.should.equal 0
    end
  end

  describe '#create' do
    before do
      @tag = Tag.create(name: 'hoge')
    end
    it 'should be saved' do
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
    it 'table should not be empty' do
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

    it 'hoge should found' do
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

    it 'should sorted by updateSequenceNum desc' do
      @tags.size.should.equal 2
      @tags[0].updateSequenceNum.should.equal 10
      @tags[1].updateSequenceNum.should.equal 5
    end
  end

  describe '.refresh_all' do

    before do
      @edam_tags = []
      @edam_tags << EW.create_tag_with_guid(
        'guid1', name:'hoge', parentGuid:'guid2',updateSequenceNum: 10)
      @edam_tags << EW.create_tag_with_guid(
        'guid2', name:'fuga', parentGuid:'guid2',updateSequenceNum: 10)
      Tag.truncate
      Tag.create(name: 'notexist')
      Tag.save_and_load
      Tag.refresh_all @edam_tags
    end

    it 'should replace all by edam tag' do
      @edam_tags.each do |edam_tag|
        tag = Tag.find_by_name(edam_tag.name)
        tag.name.should.equal edam_tag.name
        tag.updateSequenceNum.should.equal edam_tag.updateSequenceNum
      end
    end

    it 'local only tag should not exist' do
      not_found = Tag.find_by_name('notexist')
      not_found.should.be.nil
    end

  end

  describe '.exist?' do

    describe 'when record exist' do
      before do
        Tag.truncate
        Tag.save_and_load
        Tag.create
      end
      it 'shoule be true' do
        Tag.all.size.should.not.equal 0
        Tag.exist?.should.equal true
      end
    end

    describe 'when record not exist' do
      before do
        Tag.truncate
        Tag.save_and_load
      end
      it 'shoule be false' do
        Tag.all.size.should.equal 0
        Tag.exist?.should.not.equal true
      end
    end

  end

  describe '.join_name' do
    before do
      Tag.truncate
      Tag.create name:'hoge'
      Tag.create name:'fuga'
      @tags = Tag.all
    end

    describe 'tags not empty' do
      it 'should return comma separated string' do
        Tag.join_name(@tags).split(',').size.should.equal 2
        Tag.join_name(@tags).should.equal 'hoge,fuga'
       end
    end

    describe 'when tags is nil' do
      before do
         @tags = nil
     end
     it 'should return empty string' do
        Tag.join_name(@tags).should.equal ''
     end
    end
    describe 'when tags is []' do
      before do
         @tags = []
     end
     it 'should return empty string' do
        Tag.join_name(@tags).should.equal ''
     end
    end
  end
end
