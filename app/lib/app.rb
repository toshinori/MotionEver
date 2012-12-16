module BubbleWrap
  module App
    module_function
    def caches_path
      NSSearchPathForDirectoriesInDomains(13, NSUserDomainMask, true)[0]
    end
  end
end
