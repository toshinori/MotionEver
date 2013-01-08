# モデルをもとに複数のボタンを扱うViewのためのヘルパ
module MultipleButtonsViewHelper

  def generate_buttons_with_source source, action:action
    # ボタンの位置は左上から右下に配置していく感じ
    top = left = 0
    source.map do |t|
       UIButton.buttonWithType(UIButtonTypeRoundedRect).tap do |b|
        b.setTitle t.name, forState:UIControlStateNormal
        # b.styleId = 'tag-normal'
        # b.tag_name = tag
        b.size_to_fit_by_text
        if left + b.width > self.view.width
          top += b.height
          left = 0
        end
        b.frame = [[left, top], [b.width, b.height]]
        b.addTarget self,
          action:action,
          forControlEvents:UIControlEventTouchUpInside
        left += b.width
      end
    end
  end

  def locate_buttons buttons, target:target
    target.subviews.each {|v| v.removeFromSuperview}
    buttons.each {|b| target.addSubview(b)}
    target.contentSize = [self.view.width, buttons.last.top + buttons.last.height]
  end

end
