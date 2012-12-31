class ModelBase
  class << self

    def file_name
      "#{self.name.downcase}.dat"
    end

    def path
      self.documents_file self.file_name
    end

    def load
      self.deserialize_from_file self.file_name
    end

    def save
      self.serialize_to_file self.file_name
    end

    def truncate
      if File.exist?(self.path)
        File.unlink self.path
      end
    end

  end
end
