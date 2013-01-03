class NetworkActivityIndicator
  @@count = 0

  class << self

    def on
      create_queue.sync {@@count += 1}
      # rake specするとnetworkActivityIndicatorVisibleがUIApplicationに
      # 存在しないと怒られるのでテスト削除した
      UIApplication.sharedApplication.networkActivityIndicatorVisible = true
    end

    def off
      q = create_queue
      q.sync do
        @@count -= 1
        # マイナスになったらカウンタをクリアしてしまう
        # 例外を投げようかとも思ったけど、このほうが使い勝手がよさそうなので
        @@count = 0 if @@count < 0
      end

      if @@count == 0
        UIApplication.sharedApplication.networkActivityIndicatorVisible = false
      end
    end

    private
    def create_queue
      Dispatch::Queue.new(self.name)
    end

  end
end
