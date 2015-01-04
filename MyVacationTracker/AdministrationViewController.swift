import UIKit

class AdministrationViewController: UIViewController {

  @IBOutlet weak var startingBalanceTextField: UITextField!
  @IBOutlet weak var accrualRateTextField: UITextField!
  @IBOutlet weak var accrualStartDatePicker: UIDatePicker!

  @IBAction func resetAllAccrualsButtonPressed(sender: AnyObject) {
    let alert = UIAlertController(title: "Coming Soon", message: "When implemented, this will remove all previous accruals and regenerate them.", preferredStyle: UIAlertControllerStyle.Alert)
    alert.addAction(UIAlertAction(title: "Can't Wait!", style: UIAlertActionStyle.Default, handler: nil))
    self.presentViewController(alert, animated: true, completion: nil)
//    PTOAccruer().accrue()
  }

  override func viewWillAppear(animated: Bool) {
    startingBalanceTextField.text = "\(PTOItem.getStartingBalancePtoItem().hours)"
    accrualRateTextField.text = "\(PTOAccruer().accrualRate())"
    accrualStartDatePicker.date = PTOAccruer().accrualStartDate()
  }

  @IBAction func saveButtonPressed(sender: AnyObject) {
    var startingBalancePtoItem: PTOItem = PTOItem.getStartingBalancePtoItem()
    startingBalancePtoItem.hours = (startingBalanceTextField.text as NSString).doubleValue
    saveDatabase(getManagedObjectContext())

    PTOAccruer().setAccrualStartDate(accrualStartDatePicker.date)
    PTOAccruer().setAccrualRate((accrualRateTextField.text as NSString).doubleValue)

    showSuccess()
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

  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
  }

  private func showSuccess() {
    let alert = UIAlertController(title: "Updated", message: "Updates made. Go to Balance tab to see update.", preferredStyle: UIAlertControllerStyle.Alert)
    alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: nil))
    self.presentViewController(alert, animated: true, completion: nil)
  }
}

extension AdministrationViewController: UITextFieldDelegate {

  func textFieldShouldReturn(textField: UITextField) -> Bool {
    if textField == startingBalanceTextField {
      accrualRateTextField.becomeFirstResponder()
    } else if textField == accrualRateTextField {
      saveButtonPressed(UIButton())
    }
    return false
  }
}


