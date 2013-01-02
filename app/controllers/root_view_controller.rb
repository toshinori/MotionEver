class RootViewController < UIViewController
  include Logger

  attr_accessor :main_text
  attr_accessor :send_button
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

    # ツールバーのボタンを作成
    create_toolbar_button = -> image, action do
      UIBarButtonItem.alloc.initWithImage(
        UIImage.imageNamed(image),
        style: UIBarButtonItemStylePlain,
        target: self,
        action: action
        )
    end
    @send_button = create_toolbar_button.call 'send', 'send_note:'

    self.setToolbarItems([@send_button])

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
    # キーボードの監視解除
    @notify_observers.each {|_| App.notification_center.unobserve _}
  end

  def shouldAutorotateToInterfaceOrientation(orientation)
    true
  end

  def send_note(sender)

    # ログインしていない可能性があるため単純にノートを作成するのではなく
    # lamdaを作っておいて既にログインしている場合と
    # ログインをして成功した場合とで共用する
    success = -> do
      log 'login success.'
      create_note(@main_text.text)
      # ノート送信処理を起動
    end

    if EW.auth?
      success.call
      return
    end

    EW.login_with_view_controller(self,
      success: success,
      failure: method(:login_fail).to_proc)

  end

  def login_fail
    show_hud 'login failed.'
  end

  def create_note(text)
    # TODO タグとノートブックもあとで追加
    Note.create(
      text: text
      )
    Note.save
  end

  private

end
