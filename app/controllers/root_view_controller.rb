class RootViewController < UIViewController

  attr_accessor :main_text
  attr_accessor :notify_observers

  def viewDidLoad
    super
    self.view.backgroundColor = UIColor.whiteColor

    # 画面下部にツールバーを表示
    self.navigationController.setToolbarHidden(false, animated:false)

    # テキスト入力欄を追加
    @main_text = UITextView.new.tap do |t|
      t.backgroundColor = UIColor.whiteColor
      # 画面いっぱいに表示
      t.frame = [[0, 0], [self.view.width, self.view.height]]
      # リサイズ時は全体に追従する
      t.autoresizingMask =
        UIViewAutoresizingFlexibleLeftMargin   |
        UIViewAutoresizingFlexibleWidth        |
        UIViewAutoresizingFlexibleRightMargin  |
        UIViewAutoresizingFlexibleHeight       |
        UIViewAutoresizingFlexibleBottomMargin |
        UIViewAutoresizingFlexibleTopMargin
    end
    self.view.addSubview(@main_text)
  end

  def viewWillAppear(animated)
    @notify_observers = []

    # キーボード表示時にTextView、toolbarのサイズ、位置を変更する
    reduce_by_keyboard = -> n do
      kb_height = n.userInfo[:UIKeyboardFrameEndUserInfoKey].CGRectValue.size.height
      @main_text.height = self.view.height - kb_height
      self.navigationController.toolbar.top =
        App.shared.keyWindow.height -
        kb_height - self.navigationController.toolbar.height
    end


    # キーボードの表示、非表示を監視する
    @keyboard_shown_observer =
      App.notification_center.observe UIKeyboardDidShowNotification do |notify|
        reduce_by_keyboard.call(notify)
      end

    @keyboard_hide_observer =
      App.notification_center.observe UIKeyboardWillHideNotification do |notify|
        @main_text.frame = [[0, 0], [self.view.width, self.view.height]]
        self.navigationController.toolbar.top =
          App.shared.keyWindow.frame.size.height -
          self.navigationController.toolbar.height
      end

    @notify_observers << [@keyboard_shown_observer, @keyboard_hide_observer]
  end

  def viewWillDisappear(animated)
    @notify_observers.each {|_| App.notification_center.unobserve _}
  end

  def shouldAutorotateToInterfaceOrientation(orientation)
    true
  end
end
