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

end
