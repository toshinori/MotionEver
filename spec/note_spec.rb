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

  describe '.select_not_saved' do
    before do
       Note.truncate
       Note.create(status: Note::Saving)
       Note.create(status: Note::Saved)
       Note.create()
       @notes = Note.select_not_saved
    end
    it 'select NotSaved' do
      @notes.size.should.equal 1
    end
  end
end
