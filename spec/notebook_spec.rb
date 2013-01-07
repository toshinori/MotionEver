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
    it 'last_used should be today' do
      @notebook.last_used.year.should.equal Time.now.year
      @notebook.last_used.month.should.equal Time.now.month
      @notebook.last_used.day.should.equal Time.now.day
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

  describe '.order_by_date_and_num' do
    before do
      now = Time.now
      Notebook.truncate
      Notebook.create name: 'hoge',
        updateSequenceNum: 100
      Notebook.create name: 'fuga',
        updateSequenceNum: 10,
        last_used: now + 10000
      Notebook.create name: 'hige',
        updateSequenceNum: 20,
        last_used: now + 10000
      @notebooks = Notebook.order_by_date_and_num
    end
    it 'should order by last_used, updateSequenceNum desc' do
      @notebooks[0].name.should.equal 'hige'
      @notebooks[1].name.should.equal 'fuga'
      @notebooks[2].name.should.equal 'hoge'
    end
  end
end
