class Tag
  include MotionModel::Model

  columns name: :string,
    guid: :string,
    parentGuid: :string,
    updateSequenceNum: :int,
    last_used: :date

  class << self
    def file_name
      "#{Tag.name.downcase}.dat"
    end
    def load
      Tag.deserialize_from_file(Tag.file_name)
    end

    def save
      Tag.serialize_to_file(Tag.file_name)
    end

  end

end
