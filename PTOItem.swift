import Foundation
import CoreData

class PTOItem: NSManagedObject {

  @NSManaged var comments: String
  @NSManaged var date: NSDate
  @NSManaged var hours: Double
  var runningBalance: Double = 0.0

  func formattedDate() -> String {
    let dateFormatter = NSDateFormatter()
    dateFormatter.dateFormat = "MM/dd/yyyy"
    return dateFormatter.stringFromDate(date)
  }

  class func createInManagedObjectContext(moc: NSManagedObjectContext, date: NSDate, hours: Double, comments: String) -> PTOItem {
    let newItem = NSEntityDescription.insertNewObjectForEntityForName("PTOItem", inManagedObjectContext: moc) as PTOItem

    newItem.date = date
    newItem.hours = hours
    newItem.comments = comments

    return newItem
  }

  class func getStartingBalancePtoItem() -> PTOItem {
    var beginningOfTimeAFAUnixIsConcerned = NSDate(timeIntervalSince1970: NSTimeInterval(0))

    let fetchRequest = NSFetchRequest(entityName: "PTOItem")
    let predicate = NSPredicate(format: "date == %@", beginningOfTimeAFAUnixIsConcerned)
    fetchRequest.predicate = predicate

    if let fetchResults = getManagedObjectContext()!.executeFetchRequest(fetchRequest, error: nil) as? [PTOItem] {
      if fetchResults.count > 0 {
        return fetchResults[0]
      }
    }

    var startingPtoItem = createInManagedObjectContext(
      getManagedObjectContext()!,
      date: NSDate(timeIntervalSince1970: NSTimeInterval(0)),
      hours: 0,
      comments: "Starting Balance"
    )

    return startingPtoItem
  }
}
