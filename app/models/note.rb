class Note
  include MotionModel::Model

  columns title: :string,
    content: :string,
    text: :string,
    status: :integer,
    tags: :array,
    note_book: :string

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
