class LicenseViewController < UIViewController
  attr_accessor :web_view

  def viewDidLoad
    super

    view.backgroundColor = UIColor.whiteColor

    # resources/license.htmlを読み込んで表示
    @web_view = UIWebView.new.tap do |v|

      v.frame = self.view.bounds
      v.scalesPageToFit = true
      self.view.addSubview v

      path = NSBundle.mainBundle.pathForResource "lisence", ofType:'html'
      url = NSURL.fileURLWithPath path
      v.loadRequest NSURLRequest.requestWithURL url
    end

  end

end
