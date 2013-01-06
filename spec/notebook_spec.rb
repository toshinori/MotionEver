describe Notebook do

  describe '#new' do
    before do
      @notebook = Notebook.new
    end
    it 'updateSequenceNum should be 0' do
      @notebook.updateSequenceNum.should.equal 0
    end
    it 'defaultNotebook should be false' do
      @notebook.defaultNotebook.should.equal false
    end
  end

  describe '.find_by_name' do
    before do
      Notebook.truncate
      Notebook.create(name: 'hoge')
      @notebook = Notebook.find_by_name('hoge')
    end

    it 'should return Notebook(name is hoge)' do
      @notebook.should.not.nil
      @notebook.name.should.equal 'hoge'
    end
  end
end
