import Foundation
import CoreData

class AccrualItem: NSManagedObject {

  @NSManaged var date: NSDate

  class func createInManagedObjectContext(moc: NSManagedObjectContext, date: NSDate) -> AccrualItem {
    let newItem = NSEntityDescription.insertNewObjectForEntityForName("AccrualItem", inManagedObjectContext: moc) as AccrualItem
    newItem.date = date
    return newItem
  }
}
