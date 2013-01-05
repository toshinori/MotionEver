class UIViewController

  def show_hud(message)
    MBProgressHUD.showHUDAddedTo(self.navigationController.view, animated:true).tap do |hud|
      hud.mode = MBProgressHUDModeText
      hud.labelText = message
      hud.margin = 10.0
      hud.yOffset = 0.0
      hud.removeFromSuperViewOnHide = true
      hud.hide(true, afterDelay:2)
    end
  end

  def can_connect? hud = true
    return true if App.shared.delegate.reachable?

    if hud
      show_hud 'can not connect to Evernote'
    end

    false
  end

  # Evernoteからタグを取得しモデルに保存する
  # ブロックは成功時の処理、失敗時はメッセージを表示
  def refresh_all_tags &block
    return unless can_connect?

    # ログインをしていなかったらログイン
    # 成功したら再度、自身を呼び出す
    unless EW.auth?
      EW.login_with_view_controller self,
        success: -> { log 'success'; refresh_all_tags &block },
        failure: method(:login_fail).to_proc
      return
    end

    # 成功時に呼ぶブロックをProcに変換しEvernoteからのタグ取得成功時に呼び出す
    success_proc = block.to_proc if block_given?
    success = -> tags do
      log 'success list tags'
      Tag.refresh_all tags
      Tag.save_and_load
      success_proc.call unless success_proc.nil?
    end

    failure = -> err do
      show_hud 'can not get tags.'
      log err
    end

    log 'list tags'
    EW.list_tags_with_success success, failure:failure
  end

end
