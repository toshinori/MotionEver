class RootViewController < UIViewController
  include Logger
  include UseTagViewHelper

  attr_accessor :main_text
  attr_accessor :send_button, :trash_button, :tag_button
  attr_accessor :select_tag_button, :close_tag_view_button
  attr_accessor :notify_observers
  attr_accessor :tag_view_controller
  attr_accessor :selected_tags

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
    @send_button = create_toolbar_button_with_image 'send', action:'send_note'
    @trash_button = create_toolbar_button_with_image 'trash', action:'clear_note'
    @tag_button = create_toolbar_button_with_image 'tag', action:'show_tag_view'

    self.setToolbarItems([@send_button, @trash_button, @tag_button])

  end

  def viewWillAppear(animated)

    # キーボード表示時にTextView、toolbarのサイズ、位置を変更する
    reduce_by_keyboard = -> n do
      kb_height = n.userInfo[:UIKeyboardFrameEndUserInfoKey].CGRectValue.size.height
      @main_text.height = self.view.height - kb_height
      self.navigationController.toolbar.top =
        App.shared.keyWindow.height -
        kb_height - self.navigationController.toolbar.height
    end

    @notify_observers = []
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

    # 前回処理時に送信されなかったノートを送信
    NoteSender.instance.start
  end

  def viewWillDisappear(animated)
    # キーボードの監視解除
    @notify_observers.each {|_| App.notification_center.unobserve _}
  end

  def shouldAutorotateToInterfaceOrientation(orientation)
    true
  end

  def login_fail
    show_hud 'login failed.'
  end

  def send_note

    return unless can_send?

    # ログインしていない可能性があるため単純にノートを作成するのではなく
    # lamdaを作っておいて既にログインしている場合と
    # ログインをして成功した場合とで共用する
    success = -> do
      log 'login success.'
      create_note(@main_text.text)
      # ノート送信処理を起動
      NoteSender.instance.start
    end

    if EW.auth?
      success.call
      return
    end

    EW.login_with_view_controller(self,
      success: success,
      failure: method(:login_fail).to_proc)

  end

  def clear_note
    @main_text.text = ""
  end

  def create_note text
    # TODO タグとノートブックもあとで追加
    Note.create(
      text: text
      )
    Note.save
  end

  def can_send?
    @main_text.hasText and can_connect?
  end

  def show_tag_view

    show_tag_view_base = Proc.new do

      # 上部にバーを表示したいのでNavigationControllerを使用している
      @tag_view_controller = UINavigationController.alloc.initWithRootViewController TagViewController.new

      # 左上のCancelボタンを追加
      @close_tag_view_button =
        UIBarButtonItem.alloc.
          initWithBarButtonSystemItem UIBarButtonSystemItemCancel,
          target:self,
          action:'close_tag_view'

      # 右上にDoneボタンを表示
      @select_tag_button =
        UIBarButtonItem.alloc.
          initWithBarButtonSystemItem UIBarButtonSystemItemDone,
          target:self,
          action:'selected_tags'

      @tag_view_controller.topViewController.tap do |c|
        c.navigationItem.leftBarButtonItems = [@close_tag_view_button]
        c.navigationItem.rightBarButtonItems = [@select_tag_button]
      end

      self.navigationController.
        presentModalViewController @tag_view_controller, animated:true

    end

    if Tag.exist?
      show_tag_view_base.call
      return
    end

    # TODO 認証用のviewが閉じる前に処理が走ってしまうのをどうにかする
    # unless EW.auth?
    #   EW.login_with_view_controller(self,
    #     success: show_tag_view_base,
    #     failure: method(:login_fail).to_proc)
    #   return
    # end

    # タグをEvernoteから取得後、Viewを表示する
    refresh_all_tags &show_tag_view_base
  end

  def selected_tags
    @selected_tags = @tag_view_controller.topViewController.selected_tags
    log @selected_tags
    close_tag_view
  end

  def close_tag_view
    self.dismissModalViewControllerAnimated(true)
  end

  private

end
