import UIKit
import CoreData

class AddHistoryViewController: UIViewController {

  @IBOutlet weak var datePicker: UIDatePicker!
  @IBOutlet weak var hoursField: UITextField!
  @IBOutlet weak var commentsField: UITextField!

  @IBAction func addButtonPressed(sender: UIButton) {
    if let moc = self.managedObjectContext {
      PTOItem.createInManagedObjectContext(moc, date: datePicker.date, hours: (0 - (hoursField.text as NSString).doubleValue), comments: commentsField.text)
      showSuccess()
    } else {
      showFailure()
    }
  }

  func respondToSwipeGesture(gesture: UIGestureRecognizer) {
    self.view.endEditing(true)
  }

  override func viewDidLoad() {
    super.viewDidLoad()

    let directions = [
      UISwipeGestureRecognizerDirection.Up,
      UISwipeGestureRecognizerDirection.Down,
      UISwipeGestureRecognizerDirection.Right,
      UISwipeGestureRecognizerDirection.Left
      ]

    for direction in directions {
      var swipe = UISwipeGestureRecognizer(target: self, action: "respondToSwipeGesture:")
      swipe.direction = direction
      self.view.addGestureRecognizer(swipe)
    }
  }

  lazy var managedObjectContext : NSManagedObjectContext? = {
    let appDelegate = UIApplication.sharedApplication().delegate as AppDelegate
    if let managedObjectContext = appDelegate.managedObjectContext {
      saveDatabase(getManagedObjectContext())
      return managedObjectContext
    }
    else {
      return nil
    }
    }()

  private func showSuccess() {
    let alert = UIAlertController(title: "PTO Added", message: "Vacation/Sick time added. Go to Balance tab to see update.", preferredStyle: UIAlertControllerStyle.Alert)
    alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: nil))
    self.presentViewController(alert, animated: true, completion: nil)

    datePicker.date = NSDate()
    hoursField.text = ""
    commentsField.text = ""
  }

  private func showFailure() {
    let alert = UIAlertController(title: "Oops", message: "Something went wrong.  Did you enter hours as a number?", preferredStyle: UIAlertControllerStyle.Alert)
    alert.addAction(UIAlertAction(title: "Try again", style: UIAlertActionStyle.Default, handler: nil))
    self.presentViewController(alert, animated: true, completion: nil)
  }
}

extension AddHistoryViewController: UITextFieldDelegate {

  func textFieldShouldReturn(textField: UITextField) -> Bool {
    if textField == hoursField {
      commentsField.becomeFirstResponder()
    } else if textField == commentsField {
      addButtonPressed(UIButton())
    }
    textField.resignFirstResponder()
    return false
  }
}
