class TagViewController < UIViewController
  include Logger
  include MultipleButtonsViewHelper
  include UseTagViewHelper

  attr_accessor :selected_tags
  attr_accessor :buttons
  attr_accessor :refresh_button
  attr_accessor :scroll_view

  def viewDidLoad
    super

    self.view.backgroundColor = UIColor.whiteColor
    self.navigationItem.title = 'Select Tags'
    self.navigationController.setToolbarHidden(false, animated:false)

    # リフレッシュボタン
    @refresh_button = create_toolbar_button_with_image 'refresh',
      action:'refresh_all_buttons'
    self.setToolbarItems [@refresh_button]

    @selected_tags = []

    # Tagの数分だけボタンを生成
    @buttons = generate_tag_buttons

    # ScrollViewを初期化
    @scroll_view = UIScrollView.alloc.initWithFrame(
      CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)
      ).tap do |v|
      v.scrollEnabled = true
      v.contentSize = [self.view.frame.size.width, 1000]
      v.delegate = self
    end
    self.view.addSubview(@scroll_view)

    # ScrollViewにボタンを配置
    locate_buttons @buttons, target:@scroll_view
  end

  def refresh_all_buttons
    return unless can_connect?

    refresh_all_tags do
      @buttons = []
      @buttons = generate_tag_buttons
      locate_buttons @buttons, target:@scroll_view
    end
  end

  def generate_tag_buttons
    generate_buttons_with_source Tag.all, action:'tap_tag_button:'
  end

  def tap_tag_button sender

    tag_name = sender.currentTitle

    if @selected_tags.find {|t| t.name == tag_name}
      @selected_tags.delete_if {|t| t.name == tag_name}
    else
      @selected_tags << Tag.find_by_name(tag_name)
    end

    log @selected_tags
  end

end
