class Notebook < ModelBase
  include MotionModel::Model

  columns name: :string,
    guid: :string,
    updateSequenceNum: :int,
    defaultNotebook: :bool,
    last_used: :date

  def initialize(options = {})
    # updateSequenceNum、defaultNotebookに初期値を設定する
    unless options.has_key?(:updateSequenceNum)
      options[:updateSequenceNum] = 0
    end

    unless options.has_key?(:defaultNotebook)
      options[:defaultNotebook] = false
    end

    super(options)
  end

  class << self
    def find_by_name name
      Notebook.where(:name).eq(name).first
    end
  end

end
