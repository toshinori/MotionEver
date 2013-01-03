describe 'Note Model' do

  describe '#new' do
    before do
      @note = Note.new
    end

    it '#status is NotSaved' do
      @note.status.should.equal Note::NotSaved
    end
  end

  describe '#create' do
    before do
     @note = Note.create
    end

    it '#status is NotSaved' do
      @note.status.should.equal Note::NotSaved
    end
  end

  describe '#tags' do

    before do
      Tag.truncate
      Tag.create(name: 'hoge')
      Tag.create(name: 'fuga')
      @note = Note.create(tags: Tag.all)
    end

    it 'has many tag model' do
      @note.tags.size.should.equal 2
    end

    it 'tags is tag class' do
      @note.tags[0].instance_of?(Tag).should.equal true
    end

  end

  describe '.find_by_status' do
    before do
       Note.truncate
       Note.create()
       Note.create()
       Note.create()
       Note.create(status: Note::Saving)
       Note.create(status: Note::Saved)
       Note.create(status: Note::Saved)
       @notes_not_saved = Note.find_by_status(Note::NotSaved)
       @notes_saving = Note.find_by_status(Note::Saving)
       @notes_saved = Note.find_by_status(Note::Saved)
    end

    it 'can find by status' do
      @notes_not_saved.size.should.equal 3
      @notes_saving.size.should.equal 1
      @notes_saved.size.should.equal 2
    end
  end

  describe '.delete_all_saved' do
    before do
      Note.truncate
      Note.create
      Note.create(status: Note::Saving)
      Note.create(status: Note::Saved)
      Note.save
      Note.delete_all_saved
    end
    it 'Saved record not exist' do
      Note.find_by_status(Note::Saved).size.should.equal 0
    end
    it 'Other status record exist' do
      Note.find_by_status(Note::Saving).size.should.not.equal 0
      Note.find_by_status(Note::NotSaved).size.should.not.equal 0
    end
  end

  describe '#tags_for_edamnote' do
    before do
       Tag.truncate
       Tag.create(name: 'hoge')
       Tag.create(name: 'fuga')
       @tags = Tag.all
       @note = Note.create(tags: @tags)
       @tag_names = @note.tags_for_edamnote
    end
    it 'only name array' do
      @tag_names.find {|n| n == 'hoge'}.should.not.equal nil
      @tag_names.find {|n| n == 'fuga'}.should.not.equal nil
    end
  end

  describe '.save_and_load' do
    before do
       Note.truncate
       Note.create
       Note.create
       Note.save_and_load
    end
    it 'reload data' do
      Note.all.size.should.equal 2
    end
  end
end
