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

    def refresh_all(edam_notebooks)
      edam_notebooks.each do |edam_notebook|
        model = Notebook.find_by_name(edam_notebook.name) || begin
          Notebook.new(name: edam_notebook.name)
        end
        model.guid = edam_notebook.guid
        model.updateSequenceNum = edam_notebook.updateSequenceNum
        model.defaultNotebook = edam_notebook.defaultNotebook
        model.last_used = model.last_used
        model.save
      end

      Notebook.all.each do |model|
        next if edam_notebooks.find {|edam_notebook| edam_notebook.name == model.name}
        model.delete
      end
      Notebook.save_and_load
    end

  end

end
