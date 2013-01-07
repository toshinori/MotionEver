class Notebook < ModelBase
  include MotionModel::Model

  columns name: :string,
    guid: :string,
    updateSequenceNum: :int,
    defaultNotebook: :bool,
    last_used: :date

  def initialize(options = {})
    # updateSequenceNum、defaultNotebook、last_usedに初期値を設定する
    unless options.has_key?(:updateSequenceNum)
      options[:updateSequenceNum] = 0
    end

    unless options.has_key?(:defaultNotebook)
      options[:defaultNotebook] = false
    end

    unless options.has_key?(:last_used)
      options[:last_used] = Time.now
    end

    super(options)
  end

  class << self
    def find_by_name name
      Notebook.where(:name).eq(name).first
    end

    def order_by_date_and_num
      Notebook.order do |x, y|
        y.updateSequenceNum <=> x.updateSequenceNum
      end.order do |x, y|
        y.last_used <=> x.last_used
      end.all
    end

  end

end
