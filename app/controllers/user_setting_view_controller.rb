class UserSettingViewController < UITableViewController
  include Logger

  CellIdentifier = 'CELL_IDENTIFIER'

  attr_accessor :sections
  attr_accessor :user_setting

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
    section = Struct.new :title, :rows
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
      section.new('Auth', [])
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

        if @sections[section].rows.size > 0
          setting = @sections[section].rows[row]
          c.textLabel.text = setting.title
          c.accessoryView = UISwitch.alloc.initWithFrame(CGRectZero).tap do |s|
            s.on = @user_setting.send "#{setting.name}"
            # app/lib/ui_switch.rb
            s.section = section
            s.row = row
            s.addTarget self,
              action: 'tap_switch:',
              forControlEvents:UIControlEventValueChanged
          end
        else
          c.textLabel.text = 'aaa'
        end

      end
  end

  def tableView tableView, didSelectRowAtIndexPath:indexPath
    tableView.deselectRowAtIndexPath indexPath, animated:true
  end

  def tap_switch sender
    # スイッチの状態が変化したらNSUserDefaultsに反映
    setting = @sections[sender.section].rows[sender.row]
    @user_setting.send "#{setting.name}=", sender.isOn
  end

 end
