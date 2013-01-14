class UserSettingViewController < UITableViewController
  include Logger

  CellIdentifier = 'CELL_IDENTIFIER'
  Sections = %w(Beheive Auth)

  def loadView
    UITableView.alloc.initWithFrame(
      UIScreen.mainScreen.applicationFrame, style:UITableViewStyleGrouped).
      tap do |v|
      v.delegate = self
      v.dataSource = self
      self.tableView = v
    end
  end

  def viewDidLoad
    super
  end

  def numberOfSectionsInTableView(tableView)
    Sections.size
  end

  def tableView(tableView, titleForHeaderInSection:section)
    Sections[section]
  end

  def tableView(tableView, numberOfRowsInSection:section)
    case section
    when 0
      2
    else
      1
    end
  end

  def tableView(tableView, cellForRowAtIndexPath:indexPath)

    tableView.dequeueReusableCellWithIdentifier(CellIdentifier) ||
      UITableViewCell.alloc.initWithStyle(UITableViewCellStyleDefault, reuseIdentifier:CellIdentifier).tap do |c|

        case indexPath.section
        when 0
          case indexPath.row
          when 0
            c.textLabel.text = 'hoge'
          else
            c.textLabel.text = 'fuga'
          end
        when 1
            c.textLabel.text = 'hige'
        end

      end
  end
 end
