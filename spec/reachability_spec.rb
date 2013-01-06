# シミュレータ上で普通に動かした場合はちゃんと結果が返ってきたけど
# ここでは返ってこないのでコメントアウト
# describe Reachability do

#   describe 'when network enabled.' do
#     before do
#       @monitor = nil
#       @status = nil
#     end
#     it 'should not return :NotReachable' do
#       @monitor = Reachability.with_hostname('www.yahoo.co.jp') do |m|
#         @status = m.current_status
#       end
#       wait 5.0 do
#         @status.should.not.equal nil
#         @status.should.not.equal :NotReachable
#       end
#     end
#   end

  # describe 'when invalid host name.' do
  #   before do
  #     @monitor = nil
  #     @status = nil
  #   end
  #   it 'should return :NotReachable' do
  #     @monitor = Reachability.with_hostname('www.hogehoge.co.jp') do |m|
  #       @status = m.current_status
  #     end
  #     wait 30.0 do
  #       @status.should.equal :NotReachable
  #     end
  #   end
  # end
# end
