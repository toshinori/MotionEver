class Tag < ModelBase
  include MotionModel::Model

  columns name: :string,
    guid: :string,
    parentGuid: :string,
    updateSequenceNum: :int,
    last_used: :date

  def initialize(options = {})
    # updateSequenceNumに初期値を設定する
    unless options.has_key?(:updateSequenceNum)
      options[:updateSequenceNum] = 0
    end

    super(options)
  end

  class << self

    def find_by_name(name)
      Tag.where(:name).eq(name).first
    end

    def order_by_num_desc
      Tag.order{|x, y| y.updateSequenceNum <=> x.updateSequenceNum}.all
    end

    def refresh_all(edam_tags)
      edam_tags.each do |edam_tag|
        model = Tag.find_by_name(t.name) || begin
          Tag.new(name: t.name)
        end
        model.guid = edam_tag.guid
        model.parentGuid = edam_tag.parentGuid
        model.updateSequenceNum = edam_tag.updateSequenceNum
        model.save
      end
      Tag.save_and_load
    end

  end

end
