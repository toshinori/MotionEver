class Note
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
    def file_name
      "#{Note.name.downcase}.dat"
    end
    def load
      Note.deserialize_from_file(Note.file_name)
    end

    def save
      Note.serialize_to_file(Note.file_name)
    end

  end
end
