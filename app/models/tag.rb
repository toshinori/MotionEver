class Tag < ModelBase
  include MotionModel::Model

  columns name: :string,
    guid: :string,
    parentGuid: :string,
    updateSequenceNum: :int,
    last_used: :date

end
