class TagViewController < UIViewController

  attr_accessor :buttons
  attr_accessor :scroll_view

  def viewDidLoad
    super

    self.view.backgroundColor = UIColor.whiteColor

    @buttons = []
  end

  def generate_buttons_by_model
  end

end
