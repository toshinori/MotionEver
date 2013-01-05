class UIButton
  NORMAL_ID = 'tag-normal'
  SELECTED_ID = 'tag-selected'
  TextMargin = 10

  # TODO あとで使う
#   attr_accessor :tag_name

#   def switch_status
#     self.styleId =
#       self.styleId == NORMAL_ID ? SELECTED_ID : NORMAL_ID
#   end

#   def selected?
#     self.styleId == SELECTED_ID
#   end

  def sizeToFitByText
    self.tap do |b|
      label =  b.titleLabel
      label.textAlignment = UITextAlignmentCenter
      font = label.font
      button_size = label.text.sizeWithFont(font)
      b.frame = [
        [b.frame.origin.x, b.frame.origin.y],
        [button_size.width + TextMargin, button_size.height + TextMargin]
      ]
    end
  end
end
