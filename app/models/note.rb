class Note < ModelBase
  include MotionModel::Model

  NotSaved = 0
  Saving = 1
  Saved = 2

  columns title: :string,
    content: :string,
    text: :string,
    status: :integer,
    tags: :array,
    note_book: :string

  def initialize(options = {})
    # statusに初期値を設定する
    unless options.has_key?(:status)
      options[:status] = NotSaved
    end

    super(options)
  end

  class << self
    def select_not_saved
      self.where(:status).eq(NotSaved).all
    end
  end

end
