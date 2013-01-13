describe UserSetting do
  describe '.instance' do
    before do
      @user_setting = UserSetting.instance
    end
    it 'single instance' do
      @user_setting.equal?(UserSetting.instance).should.equal true
    end
  end

  describe '#getters' do
    it 'should has getters created by constans' do
      UserSetting::Settings.each do |name|
        UserSetting.instance_methods(false).include?(name.to_sym).should.equal true
      end
    end

    describe 'after set value' do
      before do
        @user_setting = UserSetting.instance
        @user_setting.send("#{UserSetting::Settings[0]}=".to_sym, true)
      end

      it 'should return set value' do
        @user_setting.send(UserSetting::Settings[0].to_sym).should.equal true
      end
    end

  end

  describe '#setters' do
    it 'should has setters created by constans' do
      UserSetting::Settings.each do |name|
        UserSetting.instance_methods(false).include?("#{name}=".to_sym).should.equal true
      end
    end
  end
end
