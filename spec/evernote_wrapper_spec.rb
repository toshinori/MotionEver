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

  describe '.create_note' do
    before do
      Tag.truncate
      Tag.create(name: 'tag1')
      Tag.create(name: 'tag2')
      @note_model = Note.new(
        text: "hoge\nfuga\n",
        tags: Tag.all,
        note_book: 'guid'
      )
      @note = EW.create_note @note_model
    end

    it 'valid edam note' do
      @note.title.should.equal 'hoge'
      @note.content.index("hoge<br/>fuga<br/>").should.not.be.nil
      @note.notebookGuid.should.equal 'guid'
    end
  end
end
