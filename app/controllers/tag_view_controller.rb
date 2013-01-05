class TagViewController < UIViewController

  attr_accessor :selected_tags
  attr_accessor :buttons
  attr_accessor :scroll_view

  def viewDidLoad
    super

    self.view.backgroundColor = UIColor.whiteColor
    self.navigationItem.title = 'Select Tags'

    @selected_tags = []

    # Tagの数分だけボタンを生成
    @buttons = generate_buttons Tag.all

    # ボタンをScrollViewに配置
    @scroll_view = UIScrollView.alloc.initWithFrame(
      CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)
      ).tap do |v|

      v.scrollEnabled = true
      v.contentSize = [self.view.frame.size.width, 1000]
      v.delegate = self
    end
    self.view.addSubview(@scroll_view)
    @buttons.each {|b| @scroll_view.addSubview(b)}
  end

  def generate_buttons tags
    # ボタンの位置は左上から右下に配置していく感じ
    top = left = 0
    tags.map do |t|
       UIButton.buttonWithType(UIButtonTypeRoundedRect).tap do |b|
        b.setTitle t.name, forState:UIControlStateNormal
        # b.styleId = 'tag-normal'
        # b.tag_name = tag
        b.sizeToFitByText
        if left + b.width > self.view.width
          top += b.height
          left = 0
        end
        b.frame = [[left, top], [b.width, b.height]]
        b.addTarget self,
          action:'on_tag_button_tapped:',
          forControlEvents:UIControlEventTouchUpInside

        left += b.width
      end
    end
  end

end
