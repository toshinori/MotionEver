class NotebookViewController < UIViewController
  include Logger
  include MultipleButtonsViewHelper
  include UseNotebookViewHelper

  attr_accessor :buttons
  attr_accessor :refresh_button
  attr_accessor :scroll_view

  def viewDidLoad
    super

    self.view.backgroundColor = UIColor.whiteColor
    self.navigationItem.title = 'Select Notebook'
    self.navigationController.setToolbarHidden(false, animated:false)

    # リフレッシュボタン
    @refresh_button = create_toolbar_button_with_image 'refresh',
      action:'refresh_all_buttons'
    self.setToolbarItems [@refresh_button]

    @selected_tags = []

    @buttons = generate_buttons_with_source Notebook.all, action:'tap_tag_button:'

    @scroll_view = UIScrollView.alloc.initWithFrame(
      CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)
      ).tap do |v|
      v.scrollEnabled = true
      v.contentSize = [self.view.frame.size.width, 1000]
      v.delegate = self
    end
    self.view.addSubview(@scroll_view)

    locate_buttons @buttons, target:@scroll_view
  end

  def refresh_all_buttons
    @buttons = []
  end
end
