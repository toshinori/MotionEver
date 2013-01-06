include SugarCube::Adjust
class AppDelegate

  attr_accessor :network_monitor
  attr_accessor :reachable

  def application(application, didFinishLaunchingWithOptions:launchOptions)

    @window = UIWindow.alloc.initWithFrame(UIScreen.mainScreen.bounds).tap do |w|
      w.rootViewController = UINavigationController.alloc.initWithRootViewController(RootViewController.new)
      w.makeKeyAndVisible()
    end

    # Evernoteとの接続設定を初期化
    EW.init_shared_host

    # Evernoteに接続できるかを監視
    @network_monitor = Reachability.with_hostname(Setting.evernote_host) do |monitor|
      @reachable = monitor.current_status != :NotReachable
    end

    # 前回処理時に保存されたデータをロード
    [Note, Tag, Notebook].each {|_| _.load}

    # Evernoteに送信済みのノートを全削除
    Note.delete_all_saved

    true
  end

  def applicationDidBecomeActive(application)
    self.network_monitor.start_notifier
  end

  def applicationWillTerminate(application)
    self.network_monitor.stop_notifier
  end

  def reachable?
    @reachable
  end

end
