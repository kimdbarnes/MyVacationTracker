import UIKit
import Foundation
import CoreData

class BalanceViewController: UIViewController {
  @IBOutlet weak var tableView: UITableView!

  var ptoItems = [PTOItem]()
  let BeginningOfTimeAFAUnixIsConcerned = NSDate(timeIntervalSince1970: NSTimeInterval(0))

  override func viewDidLoad() {
    super.viewDidLoad()

    var today = NSDate()
    if let moc = self.managedObjectContext {
      PTOItem.createInManagedObjectContext(
        moc,
        date: BeginningOfTimeAFAUnixIsConcerned,
        hours: 40,
        comments: "Starting Balance"
      )
    }
  }

  override func viewWillAppear(animated: Bool) {
    ptoItems = loadPTOItems()
    self.tableView.reloadData()
  }

  func loadPTOItems() -> [PTOItem] {
    let fetchRequest = NSFetchRequest(entityName: "PTOItem")
    let sortDescriptor = NSSortDescriptor(key: "date", ascending: true)
    fetchRequest.sortDescriptors = [sortDescriptor]

    var runningBalance = 0.0

    if let fetchResults = managedObjectContext!.executeFetchRequest(fetchRequest, error: nil) as? [PTOItem] {
      for result in fetchResults {
        runningBalance = runningBalance + result.hours
        result.runningBalance = runningBalance
      }
      return fetchResults.reverse()
    }
    return []
  }

  lazy var managedObjectContext : NSManagedObjectContext? = {
    let appDelegate = UIApplication.sharedApplication().delegate as AppDelegate
    if let managedObjectContext = appDelegate.managedObjectContext {
      return managedObjectContext
    }
    else {
      return nil
    }
    }()
}

extension BalanceViewController: UITableViewDataSource {
  func numberOfSectionsInTableView(tableView: UITableView) -> Int {
    return 2
  }

  func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return section == 0 ? 1 : ptoItems.count
  }

  func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    if (indexPath.section == 0) {
      return buildTitleRow(tableView)
    } else {
      return buildDataRow(tableView, row: indexPath.row)
    }
  }

  func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
    return true
  }

  func tableView(tableView: UITableView,
    commitEditingStyle editingStyle: UITableViewCellEditingStyle,
    forRowAtIndexPath indexPath: NSIndexPath) {

    if(editingStyle == .Delete ) {
      let ptoItemToDelete = ptoItems[indexPath.row]
      managedObjectContext?.deleteObject(ptoItemToDelete)
      ptoItems = loadPTOItems()
//      tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Automatic)
      tableView.reloadData()
    }
  }

  private func buildTitleRow(tableView: UITableView) -> UITableViewCell {
    let cell = tableView.dequeueReusableCellWithIdentifier("balanceCell") as UITableViewCell

    let dateLabel = cell.viewWithTag(1) as UILabel
    dateLabel.text = "Date"

    let actionLabel = cell.viewWithTag(2) as UILabel
    actionLabel.text = "Change"

    let balanceLabel = cell.viewWithTag(3) as UILabel
    balanceLabel.text = "Balance"

    return cell
  }

  private func buildDataRow(tableView: UITableView, row: Int) -> UITableViewCell {
    let ptoItem = ptoItems[row] as PTOItem

    let cell = tableView.dequeueReusableCellWithIdentifier("balanceCell") as UITableViewCell

    let dateLabel = cell.viewWithTag(1) as UILabel

    if ptoItem.date == BeginningOfTimeAFAUnixIsConcerned {
      dateLabel.text = "Starting Balance"
    } else {
      dateLabel.text = ptoItem.formattedDate()
    }

    let actionLabel = cell.viewWithTag(2) as UILabel
    actionLabel.text = "\(ptoItem.hours)"

    let balanceLabel = cell.viewWithTag(3) as UILabel
    balanceLabel.text = "\(ptoItem.runningBalance)"
    
    return cell
  }
  
}

extension BalanceViewController:  UITableViewDelegate {
}

