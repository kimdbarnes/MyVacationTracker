import UIKit
import CoreData

func saveDatabase(managedObjectContext: NSManagedObjectContext?) {
  var error : NSError?
  if (managedObjectContext!.save(&error) ) {
    if ((error?.localizedDescription) != nil) {
      println(error?.localizedDescription)
    }
  }
}

func getManagedObjectContext() -> NSManagedObjectContext? {
  let appDelegate = UIApplication.sharedApplication().delegate as AppDelegate
  if let managedObjectContext = appDelegate.managedObjectContext {
    return managedObjectContext
  }
  else {
    return nil
  }
}

