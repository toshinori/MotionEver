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

  def create_toolbar_button_with_image image, action:action
    UIBarButtonItem.alloc.initWithImage(
      UIImage.imageNamed(image),
      style: UIBarButtonItemStylePlain,
      target: self,
      action: action
      )
  end

end
