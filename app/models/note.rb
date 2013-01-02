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

  # tagをEvernoteのノートに設定する形式に変換
  def tags_for_edamnote
    return [] if tags.nil?
    # 名前だけの配列を作る
    tags.map { |t| t.name }
  end

  class << self

    def find_by_status(status)
      self.where(:status).eq(status).all
    end

    def delete_all_saved
      find_by_status(Saved).each do |n|
        n.delete
      end
      Note.save
    end

  end

end
