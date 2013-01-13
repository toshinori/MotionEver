class NotebookViewController < UIViewController
  include Logger
  include MultipleButtonsViewHelper
  include UseNotebookViewHelper

  attr_accessor :selected_note
  attr_accessor :buttons
  attr_accessor :refresh_button
  attr_accessor :scroll_view
  attr_accessor :on_select_note

  def viewDidLoad
    super

    self.view.backgroundColor = UIColor.whiteColor
    self.navigationItem.title = 'Select Notebook'
    self.navigationController.setToolbarHidden(false, animated:false)

    @refresh_button = create_toolbar_button_with_image 'refresh',
      action:'refresh_all_buttons'
    self.setToolbarItems [@refresh_button]

    @buttons = generate_notebook_buttons

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

  def generate_notebook_buttons
    generate_buttons_with_source Notebook.all, action:'tap_notebook_button:'
  end

  def refresh_all_buttons
    return unless can_connect?

    refresh_all_notebooks do
      @buttons = []
      @buttons = generate_notebook_buttons
      locate_buttons @buttons, target:@scroll_view
    end

  end

  def tap_notebook_button sender
    @selected_notebook = Notebook.find_by_name(sender.currentTitle)
    @on_select_note.call(@selected_notebook)
  end
end
