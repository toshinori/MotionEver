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
      # サーバから取得したTagをモデルに登録
      # 既に存在する場合は更新、そうではない場合は新規作成
      edam_tags.each do |edam_tag|
        model = Tag.find_by_name(edam_tag.name) || begin
          Tag.new(name: edam_tag.name)
        end
        model.guid = edam_tag.guid
        model.parentGuid = edam_tag.parentGuid
        model.updateSequenceNum = edam_tag.updateSequenceNum
        model.last_used = model.last_used
        model.save
      end

      # サーバに存在しないタグを削除
      Tag.all.each do |model|
        next if edam_tags.find {|edam_tag| edam_tag.name == model.name}
        model.delete
      end
      Tag.save_and_load
    end

  end

end
