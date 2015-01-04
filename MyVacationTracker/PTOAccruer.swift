import Foundation
import CoreData

class PTOAccruer {

  let DefaultAccrualRate = 6.0
  let DefaultAccrualStartDate = "2015-01-01"
  let AccrualRateKey = "AccrualRate"
  let AccrualStartDateKey = "AccrualStartDate"

  lazy var managedObjectContext : NSManagedObjectContext? = getManagedObjectContext()

  func accrue() {

    let monthlyAccrualRate = accrualRate()

    for accrualMonth in monthsToAccrueSince(accrualStartDate()) {
      PTOItem.createInManagedObjectContext(getManagedObjectContext()!, date: accrualMonth, hours: monthlyAccrualRate, comments: "Monthly accrual")
      AccrualItem.createInManagedObjectContext(getManagedObjectContext()!, date: accrualMonth)
    }

    saveDatabase(getManagedObjectContext())

  }

  func accrualStartDate() -> NSDate {
    let prefs: NSUserDefaults = NSUserDefaults.standardUserDefaults()

    var accrualStartDate = prefs.valueForKey(AccrualStartDateKey) as NSDate?

    if accrualStartDate == nil {
      let dateFormatter = NSDateFormatter()
      dateFormatter.dateFormat = "yyyy-MM-dd"
      accrualStartDate = dateFormatter.dateFromString("2015-01-01")!
      prefs.setObject(accrualStartDate, forKey: AccrualStartDateKey)
      prefs.synchronize()
    }

    return accrualStartDate!
  }

  func setAccrualStartDate(accrualStartDate: NSDate) {
    let prefs: NSUserDefaults = NSUserDefaults.standardUserDefaults()
    prefs.setObject(accrualStartDate, forKey: AccrualStartDateKey)
    prefs.synchronize()
  }

  func accrualRate() -> Double {
    let prefs: NSUserDefaults = NSUserDefaults.standardUserDefaults()

    var accrualRate = prefs.valueForKey(AccrualRateKey) as Double?

    if accrualRate == nil {
      accrualRate = 6.0
      prefs.setObject(accrualRate, forKey: AccrualRateKey)
      prefs.synchronize()
    }

    return accrualRate!
  }

  func setAccrualRate(accrualRate: Double) {
    let prefs: NSUserDefaults = NSUserDefaults.standardUserDefaults()
    prefs.setObject(accrualRate, forKey: AccrualRateKey)
    prefs.synchronize()
  }

  private func monthsToAccrueSince(accrualStartDate: NSDate) -> [NSDate] {
    var today = NSDate()
    var calendar = NSCalendar.currentCalendar()
    let year = calendar.component(.YearCalendarUnit, fromDate: today)
    let month = calendar.component(.MonthCalendarUnit, fromDate: today)

    var mostRecentAccruedMonth: NSDate? = nil

    var results = [NSDate]()

    if getPreviouslyAccruedMonths().count > 0 {
      mostRecentAccruedMonth = getPreviouslyAccruedMonths()[0]
    } else {

      var components = NSDateComponents()
      components.month = 1
      var oneMonthAfterAccrualStartDate = calendar.dateByAddingComponents(components, toDate: accrualStartDate, options: nil)

      while oneMonthAfterAccrualStartDate!.compare(today) == NSComparisonResult.OrderedAscending {
        results.append(oneMonthAfterAccrualStartDate!)
        oneMonthAfterAccrualStartDate = calendar.dateByAddingComponents(components, toDate: oneMonthAfterAccrualStartDate!, options: nil)
      }
    }

    return results
  }

  private func getPreviouslyAccruedMonths() -> [NSDate] {
    let fetchRequest = NSFetchRequest(entityName: "AccrualItem")
    let sortDescriptor = NSSortDescriptor(key: "date", ascending: false)
    fetchRequest.sortDescriptors = [sortDescriptor]

    if let fetchResults = getManagedObjectContext()!.executeFetchRequest(fetchRequest, error: nil) as? [AccrualItem] {
      if fetchResults.count > 0 {
        return fetchResults.map {
          $0.date
        }
      }
    }
    
    return []
  }
}