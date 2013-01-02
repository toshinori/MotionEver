class UiViewController
  def show_hud(message)
    MBProgressHUD.showHUDAddedTo(self.navigationController.view, animated:true).tap do |hud|
      hud.mode = MBProgressHUDModeText
      hud.labelText = message
      hud.margin = 10.0
      hud.yOffset = 150.0
      hud.removeFromSuperViewOnHide = true
      hud.hide(true, afterDelay:2)
    end
  end
end
