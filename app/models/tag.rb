class Tag < ModelBase
  include MotionModel::Model

  columns name: :string,
    guid: :string,
    parentGuid: :string,
    updateSequenceNum: :int,
    last_used: :date

  class << self

    def find_by_name(name)
      Tag.where(:name).eq(name).first
    end

    def order_by_num_desc
      Tag.order{|x, y| y.updateSequenceNum <=> x.updateSequenceNum}.all
    end

  end

end
