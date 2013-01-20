class UserSettingViewController < UITableViewController
  include Logger

  CellIdentifier = 'CELL_IDENTIFIER'

  attr_accessor :sections
  attr_accessor :user_setting
  attr_accessor :auth_button
  attr_accessor :license_view

  def loadView
    self.tableView =
      UITableView.alloc.initWithFrame(
        UIScreen.mainScreen.applicationFrame, style:UITableViewStyleGrouped).
        tap do |v|
        v.delegate = self
        v.dataSource = self
      end

    @user_setting = UserSetting.instance

    # TableViewに設定を表示するため
    # Section、Rowで管理するための構造体を作る
    section = Struct.new :title, :rows, :header, :footer
    setting = Struct.new :title, :name, :type

    @sections = [
      section.new('Notebook', [
        setting.new(
          'Select on send note',
          'select_notebook_on_send_note',
          :bool
          )
        ]),
      section.new('Tag', [
        setting.new(
          'Select on send note',
          'select_tag_on_send_note',
          :bool
          )
        ]),
      section.new('Auth', [
        setting.new(
          'Logout',
          'tap_auth_cell',
          :proc
          )
        ]),
      section.new('Misc', [
        setting.new(
          'License',
          'tap_lisence_cell',
          :proc
          )
        ])
    ]

  end

  def viewDidLoad
    super
  end

  def numberOfSectionsInTableView tableView
    @sections.size
  end

  def tableView tableView, titleForHeaderInSection:section
    @sections[section].title
  end

  def tableView tableView, numberOfRowsInSection:section
    @sections[section].rows.size
  end

  def tableView tableView, cellForRowAtIndexPath:indexPath

    tableView.dequeueReusableCellWithIdentifier(CellIdentifier) ||
      UITableViewCell.alloc.initWithStyle(UITableViewCellStyleDefault, reuseIdentifier:CellIdentifier).tap do |c|

        section = indexPath.section
        row = indexPath.row

        setting = get_setting indexPath

        unless setting.nil?
          case setting.type
          when :bool
            c.textLabel.text = setting.title
            c.accessoryView = UISwitch.alloc.initWithFrame(CGRectZero).tap do |s|
              s.on = @user_setting.send "#{setting.name}"
              s.addTarget self,
                action: 'tap_switch:',
                forControlEvents:UIControlEventValueChanged
            end
          when :proc
            if setting.name == 'Auth'
              c.textLabel.text = auth_cell_title
            else
              c.textLabel.text = setting.title
              c.accessoryType = UITableViewCellAccessoryDisclosureIndicator
            end
          end
        else
          c.textLabel.text = 'aaa'
        end

      end
  end

  def tableView tableView, didSelectRowAtIndexPath:indexPath
    tableView.deselectRowAtIndexPath indexPath, animated:true

    setting = get_setting indexPath
    return if setting.nil? or setting.type != :proc

    send setting.name.to_sym, indexPath
  end

  def get_setting indexPath
    if @sections[indexPath.section].rows.size == 0
      return nil
    end
    @sections[indexPath.section].rows[indexPath.row]
  end

  def tap_switch sender
    # スイッチの状態が変化したらNSUserDefaultsに反映
    index_path = self.tableView.indexPathForCell sender.superview
    setting = @sections[index_path.section].rows[index_path.row]
    @user_setting.send "#{setting.name}=", sender.isOn
  end

  def tap_auth_cell indexPath
    return unless can_connect?

    if EW.auth?
      EW.logout
      switch_auth_cell_title indexPath
      return
    end

    EW.login_with_view_controller(self,
      success: -> { switch_auth_cell_title indexPath },
      failure: -> { login_fail })
  end

  def auth_cell_title
    return 'Logout' if EW.auth?
    'Login'
  end

  def switch_auth_cell_title indexPath
    c = self.tableView.cellForRowAtIndexPath indexPath
    c.textLabel.text = auth_cell_title
  end

  def tap_lisence_cell indexPath
   @license_view = LicenseViewController.new
   self.navigationController.pushViewController @license_view, animated:true
  end
 end
